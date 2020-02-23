function Test-ServerRoleInstallState {
    <#
.SYNOPSIS
    Tests if a given ServerRole is installed on a Server.
.DESCRIPTION
    The function checks the InstallState property of a parameter-given ServerRole.
    It says "installed" or "available" and you can decide what to do.
    So if it's "available" you may do an "Add-WindowsFeature" in the if-statement.
    Now it only gives you Verbose-Output.
.EXAMPLE
    Test-ServerRoleInstallState -Name foo -ServerName bar
.PARAMETER ServerRole
    Mandatory. The ServerRole you are looking for, e.g. DHCP, DNS...
    ValidateScript will check if the Role you typed really exists.
    If not, it will throw an individual error.
.PARAMETER ComputerName
    Optional. The Computer from which you want to retrieve the information.
    If you omit this parameter it will run against $env:COMPUTERNAME.
.NOTES
    File Name: Test-ServerRoleInstallState.ps1
    Author: Oliver Jaekel
    eMail: oj@jaekel-edv.de
    Twitter: @JaekelEDV
    GitHub: https://github.com/JaekelEDV
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $True)]
        [ValidateScript({
                if (Get-WindowsFeature -Name $_){
                    $true
                }
                else {
                    throw "'$_' IS NOT A VALID SERVER-ROLE!"
                }
            })]
        [string]$ServerRole,

        [Parameter()]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $RoleInstallState = (Get-WindowsFeature -Name $ServerRole -ComputerName $ComputerName).InstallState

    if ($RoleInstallState -eq 'Available') {
        Write-Verbose -Message "ServerRole $ServerRole is available."
    }
    if ($RoleInstallState -eq 'Installed'){
        Write-Verbose -Message "ServerRole $ServerRole is already installed."
    }
}
