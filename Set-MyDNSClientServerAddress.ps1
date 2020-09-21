<#
.SYNOPSIS
   Sets new DNS-Server on chosen NIC.

.DESCRIPTION
   Sets new DNS-Server on chosen NIC.
   Of course you may adjust the following to your needs:
   The possible DNS-Servers are PiHole and Router (ValidateSet).
   The possible IP-Addresses are hardcoded in variables.
   You can tab out the NIC with AutoCompletion.

.EXAMPLE
   Set-MyDNSClientServerAddress -NIC "foo" -DNSServerAddress [PiHole | Router]

.PARAMETER NIC
   Mandatory. The name of the NIC you want to set the DNS-Server.
   You can tab to autocomplete NICs installed on the machine.

.PARAMETER DNSServerAddress
   The DNSServer to be used. The possible ones are PiHole and Router.
   You may adjust this to your needs.

.INPUTS
   No inputs to this function.

.OUTPUTS
   No output from this function.

.NOTES
   The reason I wrote this function was to quickly change used DNS-Servers in my
   Lab-Environment. Sometimes I want the PiHole-DNS, sometimes I don't. That's all.
   File Name: Set-MyDNSClientServerAddress.ps1
   Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
#>
Function Set-MyDNSClientServerAddress {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$NIC,

        [Parameter(Mandatory = $true)]
        [ValidateSet('PiHole','Router')]
        [string]$DNSServerAddress
    )

    [IPAddress]$pihole = '10.0.0.2'
    [IPAddress]$router = '10.0.0.100'

    switch ($DNSServerAddress) {
        'PiHole' {
            Set-DnsClientServerAddress -InterfaceAlias $NIC -ServerAddresses $pihole -PassThru
        }
        'Router' {
            Set-DnsClientServerAddress -InterfaceAlias $NIC -ServerAddresses $router -PassThru
        }
    }
}

#Since we must assume an InterfaceAlias with whitespaces in its name, we add quotation marks.
#Otherwise the parameter would throw an error.
$NIC = {
    (Get-NetIPConfiguration).InterfaceAlias | ForEach-Object { ('"' + (($_) + '"')) }
}

$AutoCompleteNIC  = @{
    CommandName   = 'Set-MyDNSClientServerAddress'
    ParameterName = 'NIC'
    ScriptBlock   = $NIC
}
Register-ArgumentCompleter @AutoCompleteNIC
