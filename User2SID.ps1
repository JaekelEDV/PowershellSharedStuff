#region emergency brake
throw "NO! This ps1 should not be executed! This is no script!"
#endregion

#Domain User to SID
$objUser = New-Object System.Security.Principal.NTAccount('domainname', 'username')
$SID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SID.Value

#Local User to SID
$objUser = New-Object System.Security.Principal.NTAccount('<local username>')
$SID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SID.Value

#SID to (Domain)User
$objSID = New-Object System.Security.Principal.SecurityIdentifier ('<SID>')
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value

#List all Domainusers (Groups) with SIDs
Get-ADUser -Filter * | Select-Object -Property Name, SID | Sort-Object -Property Name
Get-ADGroup -Filter * | Select-Object -Property Name, SID | Sort-Object -Property Name

#List all local Users (Groups) with SIDs
Get-LocalUser | Select-Object -Property Name, SID | Sort-Object -Property Name
Get-LocalGroup | Select-Object -Property Name, SID | Sort-Object -Property Name

#Have a SID but no idea if it's a user, group or computer? Try this:
$SID = '<SID>'
Get-ADObject -Filter "objectSid -eq '$SID'" | Select-Object Name, ObjectClass


