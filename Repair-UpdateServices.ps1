<#
.SYNOPSIS
    Repair-UpdateServices.ps1 stops Windows Update relevant services and renames relevant folders.
.DESCRIPTION
    Repair-UpdateServices.ps1 can help if Windows Update throws any errors or updates simply
    won't finish installing.
    Repair-UpdateServices.ps1 stops the following services:
        wuauserv - Automatic Updates service
        cryptSvc - Cryptographic Services
        BITS - Background Intelligent Transfer Service
        msiserver - Windows Installer service
    Repair-UpdateServices.ps1 renames the following folders:
        "C:\Windows\SoftwareDistribution"
        "C:\Windows\System32\catroot2"
    Then the above services are started again.
    A reboot is recommended, but has to be confirmed.
.EXAMPLE
    PS C:\> Repair-UpdateServices.ps1
    Simply execute the ps1-script.
.LINK
    https://support.microsoft.com/en-us/windows/troubleshoot-problems-updating-windows-10-188c2b0f-10a7-d72f-65b8-32d177eb136c
.NOTES
    File Name: Repair-UpdateServices.ps1
    Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
#>
#Requires -RunAsAdministrator

#region Function stopping the services
function Stop-MyUpdateServices {

    [CmdletBinding()]
    param ()
    $svc = Get-Service -Name "wuauserv", "cryptSvc", "BITS", "msiserver"
    $svc |
    Where-Object{ $_.status -eq 'Running' } |
    Stop-Service -Force
    $svc
}
#endregion

#region Function renaming the folders
function Rename-MyFolders {
    [CmdletBinding()]
    param ()
    $SoftwareDistribution = "$ENV:SYSTEMROOT\SoftwareDistribution"
    $catroot2 = "$ENV:SYSTEMROOT\System32\catroot2"
    Rename-Item $SoftwareDistribution -NewName "SoftwareDistribution.old" -Force
    Rename-Item $catroot2 -NewName "Catroot2.old" -Force
}
#endregion

#region Function starting the services.
function Start-MyUpdateServices {
    [CmdletBinding()]
    param ()
    $svc = Get-Service -Name "wuauserv", "cryptSvc", "BITS", "msiserver"
    $svc |
    Where-Object{ $_.status -eq 'Stopped' } |
    Start-Service
    $svc
}
#endregion

#region And action!
Stop-MyUpdateServices
Rename-MyFolders
Start-MyUpdateServices
Restart-Computer -Confirm:$true
#endregion
