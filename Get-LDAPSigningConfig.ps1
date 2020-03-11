<#
.SYNOPSIS
    Get-LDAPSigningConfig.ps1 checks Domain Controllers for LDAP-Signing and Channel-Binding configs.
.DESCRIPTION
    Get-LDAPSigningConfig.ps1 needs Domain Credentials and a file with the names of the Domain Controllers.
    It is designed to run against virtual DCs, but this could easily be changed to physical machines.
    It checks:
    -If advanced LDAP Interface Logging is enabled
    -Registry Value for LDAP-Signing
    -Registry Value for LDAP-Channel-Binding
    -Event-IDs 2886-2889
.NOTES
    File Name: Get-LDAPSigningConfig.ps1
    Author: Oliver Jaekel | oj@jaekel-edv.de | @JaekelEDV | https://github.com/JaekelEDV
#>
$DomainCreds = Get-Credential -UserName test\administrator -Message "Please enter Domain Credentials"
$DomainControllers = Get-Content -Path C:\DomainControllers.txt

foreach ($DomainController in $DomainControllers) {

    Invoke-Command -VMName $DomainController -Credential $DomainCreds -ScriptBlock {

        $LoggingState = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Diagnostics |
        Select-Object -ExpandProperty '16 LDAP Interface Events'
        if ($LoggingState -eq 0) {
            Write-Host "$using:DomainController has no advanced logging configured." -ForegroundColor Red
            }
        if ($LoggingState -eq 2) {
            Write-Host "$using:DomainController has advanced logging configured."
        }

        $LDAPSigning = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Parameters |
        Select-Object -ExpandProperty ldapserverintegrity -ErrorAction SilentlyContinue
        if ($LDAPSigning -eq '0') {
            Write-Host "$using:DomainController has LDAP Signing disabled." -ForegroundColor Red
        }
        if ($LDAPSigning -eq '1') {
            Write-Host "$using:DomainController has LDAP Signing enabled, but not required."
        }
        if ($LDAPSigning -eq '2') {
            Write-Host "$using:DomainController has LDAP Signing enabled, is required."
        }
        if ($LDAPSigning -eq $null) {
            Write-Host "$using:DomainController has no registry entry for LDAP-Signing." -ForegroundColor Red
        }

        $LDAPChannelBinding = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Parameters |
        Select-Object -ExpandProperty LdapEnforceChannelBinding -ErrorAction SilentlyContinue
        if ($LDAPChannelBinding -eq '0') {
            Write-Host "$using:DomainController has LDAP Channel Binding disabled." -ForegroundColor Red
        }
        if ($LDAPChannelBinding -eq '1') {
            Write-Host "$using:DomainController has LDAP Channel Binding enabled, but not required."
        }
        if ($LDAPChannelBinding -eq '2') {
            Write-Host "$using:DomainController has LDAP Channel Binding enabled, is required."
        }
        if ($LDAPChannelBinding -eq $null) {
            Write-Host "$using:DomainController has no registry entry for LDAP-ChannelBinding." -ForegroundColor Red
        }

        $Event2886 = (Get-EventLog -LogName 'Directory Service' -InstanceId 2886 -Source Microsoft-Windows-ActiveDirectory.DomainService -ErrorAction 'SilentlyContinue')

        if ($Event2886) {
            Write-Host "$using:DomainController logged attempts of unsigned LDAP binds (no server request), EventID 2886." -ForegroundColor Red
            Write-Host "DIRLOG_ENCOURAGE_LDAP_SIGNING; DC doesn't request secure LDAP binding at all."
        }
        else {
            Write-Host "$using:DomainController has not logged attempts of unsigned LDAP binds (no server request), no EventID 2886."
        }

        $Event2887 = (Get-EventLog -LogName 'Directory Service' -InstanceId 2887 -Source Microsoft-Windows-ActiveDirectory.DomainService -ErrorAction 'SilentlyContinue')

        if ($Event2887) {
            Write-Host "$using:DomainController logged attempts of unsigned LDAP binds (no client request), EventID 2887." -ForegroundColor Red
            Write-Host "DIRLOG_WOULD_REJECT_UNSIGNED_CLIENTS; DC not configured to reject unsecure bindings (compatibility)."
        }
        else {
            Write-Host "$using:DomainController has not logged attempts of unsigned LDAP binds (no client request), no EventID 2887."
        }

        $Event2888 = (Get-EventLog -LogName 'Directory Service' -InstanceId 2888 -Source Microsoft-Windows-ActiveDirectory.DomainService -ErrorAction 'SilentlyContinue')

        if ($Event2888) {
            Write-Host "$using:DomainController logged attempts of unsigned LDAP binds, EventID 2888."
            Write-Host "DIRLOG_HAVE_REJECTED_UNSIGNED_CLIENTS; DC configured to reject unsecure bindings."
        }
        else {
            Write-Host "$using:DomainController has not logged attempts of unsigned LDAP binds, no EventID 2888."
        }

        $Event2889 = (Get-EventLog -LogName 'Directory Service' -InstanceId 2889 -Source Microsoft-Windows-ActiveDirectory.DomainService -ErrorAction 'SilentlyContinue')

        if ($Event2889) {
            Write-Host "$using:DomainController has logon events without LDAP-signing, EventID 2889." -ForegroundColor Red
            Write-Host "DIRLOG_UNSIGNED_CLIENT_DETAILS; Client performed unsecure binding without signing request OR simple cleartext bind. Only visible with enhanced logging."
        }
        else {
            Write-Host "$using:DomainController has no logon events without LDAP-signing, no EventID 2889."
        }
    }
}

Write-Host "Be aware: this script only checks for some events and registry entries. You better double-check..." -ForegroundColor Magenta
Write-Host "https://support.microsoft.com/en-us/help/4520412/2020-ldap-channel-binding-and-ldap-signing-requirements-for-windows" -ForegroundColor Magenta


