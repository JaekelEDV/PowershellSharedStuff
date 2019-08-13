$Props = 'Name', @{Name = 'Size in GB'; Expression = {$_.Length / 1GB -as [int]}}, @{Name = 'Size in MB'; Expression = {$_.Length / 1MB -as [int]}}, 'Directory'
Get-ChildItem -Recurse | Sort -Descending -Property Length | select -First 5 $Props | Format-List
