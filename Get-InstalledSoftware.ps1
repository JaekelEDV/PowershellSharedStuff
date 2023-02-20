<#
    .SYNOPSIS
        Get-InstalledSoftware.ps1 lists installed Software on a Windows System

    .DESCRIPTION
        Get-InstalledSoftware.ps1 uses the uninstall-information in the registry to find installed software.
        It uses the paths for AllUser, CurrentUser, AllUser32 and CurrentUser32.
        This should find the vast majority of installed software
        but using this technique doesn't guarantee finding every program.

    .PARAMETER DisplayName
        DisplayName narrows the output to desired programs.
        Omitting this parameter results in the default which is all ("*").

    .PARAMETER DisplayVersion
        DisplayVersion narrows the output to desired versions.
        Omitting this parameter results in the default which is all ("*").

    .PARAMETER InstallDate
        InstallDate narrows the output to desired InstallDates.
        Omitting this parameter results in the default which is all ("*").

    .PARAMETER UninstallString
        DisplayVersion narrows the output to UninstalledStrings (Paths).
        Omitting this parameter results in the default which is all ("*").

    .EXAMPLE
        .\Get-InstalledSoftware.ps1
        This will give you the complete list with
        DisplayName, DisplayVersion, InstallDate and UninstallString.

    .EXAMPLE
        .\Get-InstalledSoftware.ps1 -Displayname *foo*
        This will give you all Programs with the string "foo" in the Name.

    .EXAMPLE
        .\Get-InstalledSoftware.ps1 -InstallDate *2021*
        This will give you all Programs installed in 2021.

    .EXAMPLE
        .\Get-InstalledSoftware.ps1 -Displayversion 1.2*
        This will give you all Programs with a Version starting with "1.2".

    .EXAMPLE
        .\Get-InstalledSoftware.ps1 -UninstallString 'C:\Program Files (x86)*'
        This will give you all Programs where the uninstaller is found in
        'C:\Program Files (x86)*'

    .LINK
        TODO: Online version: https://github.com/JaekelEDV/

    .NOTES
        File Name: Get-InstalledSoftware.ps1
        Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
    #>

#region Parameters
[CmdletBinding(SupportsShouldProcess=$true)]
param
(
    $DisplayName='*',
    $DisplayVersion='*',
    $InstallDate='*',
    $UninstallString='*'
)
#endregion

#region Setting variables for the registry paths to search through
$pathAllUser = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$pathCurrentUser = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$pathAllUser32 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$pathCurrentUser32 = "Registry::HKEY_CURRENT_USER\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
#endregion

#region Setting up Timestamp and ReportDir
$RunDate = Get-Date -UFormat "%d.%m.%Y-%H.%M"

$ReportDir = "$env:HOMEPATH\Desktop\InstalledSoftware\"
if (!(Test-Path $ReportDir)) {
    New-Item -Type Directory -Path $ReportDir | Out-Null
}
#endregion

#region Getting the info out of the registry, then filter and sort
$programs = (
    Get-ItemProperty -Path $pathAllUser, $pathCurrentUser, $pathAllUser32, $pathCurrentUser32 |
    Select-Object -Property DisplayName, DisplayVersion, InstallDate, UninstallString  |
    Where-Object DisplayName -ne $null |
    Where-Object DisplayName -like $DisplayName |
    Where-Object DisplayVersion -like $DisplayVersion |
    Where-Object UninstallString -like $UninstallString |
    Where-Object InstallDate -like $InstallDate |
    Sort-Object -Property DisplayName
)
#endregion

#region Putting the info Out-Host, to a txt-file and to a csv-file
$programs | Out-Host

$programs | Out-File -FilePath "$ReportDir\InstalledPrograms_$RunDate.txt" -Width 2000

$programs | Export-Csv -Path "$ReportDir\InstalledPrograms_$RunDate.csv"
#endregion
