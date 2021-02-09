function Test-CredentialGuard {
    [CmdletBinding()]
    param ()

    $params = @{
        ClassName = 'Win32_DeviceGuard'
        Namespace = 'root\Microsoft\Windows\DeviceGuard'
    }
    $DevGuard = Get-CimInstance @params
    if ($DevGuard.SecurityServicesConfigured -contains 1) {
        Write-Host "Credential Guard configured." -ForegroundColor Green
    }
    else {
        Write-Host "Credential Guard not configured." -ForegroundColor Red
    }
    if ($DevGuard.SecurityServicesRunning -contains 1) {
        Write-Host "Credential Guard is running." -ForegroundColor Green
    }
    else {
        Write-Host "Credential Guard is not running." -ForegroundColor Red
    }
}
