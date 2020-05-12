<#
.SYNOPSIS
    Remove-NetIPConfig resets the NIC-Config to DHCP, hence destroying all other config.
.DESCRIPTION
    Remove-NetIPConfig
.EXAMPLE
    PS C:\> Remove-NetIPConfig -NIC 'Ethernet'
.PARAMETER NIC
    Mandatory. Specifies the NIC you want to reset to DHCP.
    ArgumentCompletion let's you tab out all systems' NICs.
.NOTES
    Remove-NetIPConfig uses netsh which is called via Invoke-Expression. It serves as an alternative to
    PS native variants. Sometimes this way seems to be more stable - the good ol'days, you know...
    File Name: Remove-NetIPConfig.ps1
    Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
#>
function  Remove-NetIPConfig {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $True)]
        [string]$NIC
    )

    $NetshDHCP = 'interface ipv4 set address name="LAN" source=dhcp'
    $NetshDNS  = 'interface ipv4 delete dnsservers name="LAN" address=all'

    Invoke-Expression "netsh $NetshDHCP"
    Invoke-Expression "netsh $NetshDNS"
}

$GetNIC = { (Get-NetAdapter).name }
$AutoCompleteNIC = @{
    CommandName   = 'Remove-NetIPConfig'
    ParameterName = 'NIC'
    ScriptBlock   = $GetNIC
}
Register-ArgumentCompleter @AutoCompleteNIC
