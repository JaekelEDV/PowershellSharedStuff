<#
.SYNOPSIS
    Test-IsDomainController reveals if a target-system is a DomainController.
.DESCRIPTION
    Test-IsDomainController uses Win32_OperatingSystem to query the ProductType of an installed OS.
    This way you're able to say if it's a DC, a Server-OS or a Client-OS:
    isClientOS: ProductType="1"
    isServerisDC: ProductType="2"
    isServerOS: ProductType="3".
.EXAMPLE
    dot source it... PS C:\>. .\Test-IsDomainController.ps1
    run it... Test-IsDomainController
.NOTES
    File Name: Test-IsDomainController.ps1
    Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
#>
function Test-IsDomainController {
    [CmdletBinding()]
    param (
    )
    $InformationPreference = "continue"
    $checkProductType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
    if ($checkProductType -eq '2') {
        Write-Information "The machine IS a DomainController."
    }
    if ($checkProductType -eq '1') {
        Write-Information "The machine is NO DomainController (ClientOS)."
    }
    if ($checkProductType -eq '3') {
        Write-Information "The machine is NO DomainController (ServerOS)."
    }
}
