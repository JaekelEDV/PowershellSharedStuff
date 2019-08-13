<#
.SYNOPSIS
Function Get-MACVendor returns the vendor for a given MAC-Address.
.DESCRIPTION
This script uses the API of https://macvendors.co. With Invoke-WebRequest (hence Version 3.0 is needed) it generates an output as xml.
.PARAMETER MAC
This is the only but mandatory parameter. Please enter a valid MAC-Address.
It works both with colons or hyphens - you decide.
.EXAMPLE
Execute Get-MACVendor.ps1 directly from shell with dot sourcing
. .\Get-MACVendor.ps1
Get-MACVendor -MAC Value
.NOTES
Author: Oliver Jäkel | oj@jaekel-edv.de | @JaekelEDV
with special support of @St_Meissner - thanks!
#>
#requires -Version 3.0
Function Get-MACVendor
{
    [CmdletBinding(SupportsShouldProcess = $True)]
    param (
        [Parameter(Mandatory = $true, Helpmessage = 'Enter a valid MAC-Address')]
        [string] $MAC
    )
    Try
    {
        if ($PSCmdlet.ShouldProcess($MAC))
        {

            [string]$url = 'https://macvendors.co/api/'           #The site provides an api...
            $request = Invoke-WebRequest -Uri "$url/$MAC/xml"     #...and an output as xml - great!!!
            [xml]$vendor = $request.content                       #Converts data to xml; "vendor" (company) is in the 'content'-section
            if ($vendor.InnerXml.Contains('no result') -ne $True)
            {
                $vendor.DocumentElement
            }
            else
            {
                Write-Output -InputObject "No vendor found for $mac"
            }
        }
    }
    Catch
    {
        Write-Output -InputObject $_.Exception.Message
    }
}
