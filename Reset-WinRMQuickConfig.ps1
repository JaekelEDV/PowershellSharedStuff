<#
.SYNOPSIS
This function is meant to undo all the changes that have been configured with WinRM quickconfig.

.DESCRIPTION
WinRM quickconfig does the following:
    WinRM service is set to Automatic (delayed) and started
    HTTP-Listener is created for all IP Addresses
    Firewall Exceptions are created for Windows Remote Management
    changes to LocalAccountTokenFilterPolicy
This function checks these configs and reverts them when they were applied.

.PARAMETER Name
There are no parameters.

.EXAMPLE
Simply execute the fuction.

.NOTES
Author: Oliver Jäkel | oj@jaekel-edv.de | @JaekelEDV

.LINK
http://github.com/jaekeledv
#>

function Reset-WinRMQuickConfig {
    [CmdletBinding()]
    param (
        $InformationPreference = 'Continue',
        $WinRMSvc = (Get-Service -Name WinRM).Status
    )

    #Since every following cmdlet will fail, when the WinRM-Service is not running, let's check it first.
    if ($WinRMSvc -eq 'Stopped') {
        throw 'WinRM-Service is not running. It is unlikely this machine has been configured for remote management. Stopping.'
    }

    #region Check for HTTP-Listener. Find one - kill it.
    $listener = (Get-WSManInstance -ResourceURI winrm/config/listener -SelectorSet @{Address = "*"; Transport = "http" })

    if ($listener -eq $null) {
        Write-Information -MessageData "No Listener configured"
    }

    if ($listener -ne $null) {
        Remove-Item -Path 'WSMan:\localhost\Listener\*' -Recurse
        Write-Information -MessageData "[+]Removing HTTP Listener"
    }
    #endregion

    #region check firewall for Windows Remote Management Exception. If present, disable it.
    $FWRule = (Get-NetFirewallRule |
    Where-Object { $_.Name -eq "WINRM-HTTP-In-TCP" -or $_.Name -eq "WINRM-HTTP-In-TCP-Public" })

    if ($FWRule -eq $null) {
        Write-Information -MessageData "No WinRM Firewall Rules configured"
    }

    if ($FWRule -ne $null) {
        $FWRule | Set-NetFirewallRule -Enabled False
        Write-Information -MessageData "[+]Disabling WinRM Firewall Rules"
    }
    #endregion

    #region ONLY FOR WORKGROUP COMPTERS, DOMAIN MEMBERS ARE NOT AFFECTED.
    #Check registry for LocalAccountTokenFilterPolicy. Enabled would be Value 1.
    #Value 0 prevents remote sessions.
    $isDomainJoined = (Get-WmiObject win32_computersystem).PartofDomain
    $RegFilterPolicy = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system').LocalAccountTokenFilterPolicy

    if ($RegFilterPolicy -eq $null) {
        Write-Information -MessageData "No Registry Key for LocalAccountTokenFilterPolicy found"
    }

    if ($isDomainJoined -eq $true) {
        Write-Information -MessageData "System is domain-joined, no action required"
    }

    if ($RegFilterPolicy -ne $null) {
        Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name LocalAccountTokenFilterPolicy -Value 0
        Write-Information -MessageData "[+]Setting LocalAccountTokenFilterPolicy to 0"
    }
    #endregion

    #region Stop WinRM service and set StartupType to disabled.
    if ($WinRMSvc -eq 'Running') {
        Stop-Service -Name WinRM -Force
        Set-Service -Name WinRM -StartupType 'Disabled'
        Write-Information -MessageData "[+]Stopping WinRM-Service"
        Write-Information -MessageData "[+]Disable Startup WinRM-Service"
    }
    #endregion
}
