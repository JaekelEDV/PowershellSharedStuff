$props = 'Name',
@{Name = 'Size in GB'; Expression = { $_.Length / 1GB -as [int] } },
@{Name = 'Size in MB'; Expression = { $_.Length / 1MB -as [int] } },
'Directory'
Get-ChildItem -Recurse |
Sort-Object -Descending -Property Length |
Select-Object -First 5 $props |
#Format-List
Format-Table
