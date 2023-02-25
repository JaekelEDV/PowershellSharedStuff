<#
      .SYNOPSIS
      Install-ChocoProgs.ps1 downloads Chocolatey and installs it together with selected programs.
      .DESCRIPTION
      This Script downloads and installs Chocolatey. If choco is already installed, it will initiate an upgrade.
      Via the Hashtable $progs you might define the desired programs you wish to install.
      A transcript is running so you'll find all the operations choco put out to the host in a txt-file when finished.
      .EXAMPLE
      .\Install-ChocoProgs
      .NOTES
      Author: Oliver Jäkel | oj@jaekel-edv.de | @JaekelEDV
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param ()

#Requires -RunAsAdministrator

#region Starting a transcript
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
$RunDate = Get-Date -UFormat "%d.%m.%Y-%H.%M"
Start-Transcript -Path "$env:userprofile\Desktop\LOG_Install-ChocoProgs_$RunDate.txt" -IncludeInvocationHeader
#endregion

#Checking for choco install. If there, doing an upgrade
if(-not (Test-Path "C:\ProgramData\chocolatey\choco.exe")) {
    Write-Host "No Choco found. Installing..." -ForegroundColor Yellow

    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    Catch {
        $error[0]
    }
}

else {
    Write-Host "Choco is already installed. We're doing an upgrade first..." -ForegroundColor Yellow
    choco upgrade chocolatey -y
}
#endregion

#region Installing the desired programs
$progs = @(
    'chocolatey-core.extension'
    'powershell-core'
    'sysinternals'
    'notepadplusplus'
    'vscode'
    'microsoft-windows-terminal'
    'csved'
)

Write-Host ""
Write-Host ""
Write-Host "[+]Installing the folowing programs now:" -ForegroundColor Yellow
Write-Host "==============================================="
$progs.Split(" ")
Write-Host "==============================================="
Write-Host ""
Write-Host ""

foreach ($prog in $progs) {
    choco install $prog -y
}
#endregion

#region Stopping transcript
Stop-Transcript
#endregion
