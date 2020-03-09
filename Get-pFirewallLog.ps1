#region Defining LogFile and check existence. If not exist - stop script.
$LogFile = "$env:SystemRoot\System32\LogFiles\Firewall\pfirewall.log"
$checkLog = Test-Path -Path $LogFile

if ($checkLog -eq $true) {
    Write-Verbose "Logfile found."
}
else {
    Write-Host "That's all folks... No logfile found." -ForegroundColor Red
}
#endregion

#region Defining Path to copy the logfile to. Check if exists, else create.
$DestPath = "$env:HOMEDRIVE\temp\"
$checkDestPath = Test-Path -Path $DestPath

if ($checkDestPath -eq $true) {
    Write-Verbose "DestinationPath found."
}
else {
    New-Item -ItemType Directory $DestPath | Out-Null
}
#endregion

#region Copy and convert the Logfile.
Copy-Item -Path $LogFile -Destination $DestPath

#Getting content of copy of pfirewall.log
$Log = (Get-ChildItem -Path $DestPath | Get-Content)
$Log = $Log.replace("#Fields: ","")
$LogContent = $Log | ConvertFrom-Csv -Delimiter ' '

$LogContent | Out-GridView
#endregion

#Example: Filtering the objects
#$LogContent | Where-Object {$_."src-ip" -eq "1.2.3.4" -and $_."dst-port" -eq 443} | Out-GridView
