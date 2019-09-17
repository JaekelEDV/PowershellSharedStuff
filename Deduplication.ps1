#region emergency brake
throw "NO! This ps1 should not be executed! This is no script!"
#endregion

#Collection of Deduplication releated PS cmdlets

#Install the Feature
Add-WindowsFeature -Name FS-Data-Deduplication

#List the Cmdlets
Get-Command *dedup*

#Estimate how much Diskspace might be saved with C:\Windows\System32\ddpeval.exe
#CAUTION: Might take a while...
C:\Windows\System32\ddpeval.exe e:

#Enable Dedup per Volume; Usage Type 'Default for Fileserver', 'Hyper-V' for VDI, 'Backup' for DPM
Enable-DedupVolume -Volume e: -UsageType Default -Verbose

#CAUTION: There is a default set to start Dedup only for files older 3 days!
#MinFileAge 0
Set-DedupVolume -Volume e: -MinimumFileAgeDays 0

#Let's do it!
Start-DedupJob -Volume e: -Type Optimization

#Check the Job - be patient...
Get-DedupJob -Volume e:

#Statistics
Get-DedupStatus -Volume e:
Get-DedupMetadata -Volume e:
