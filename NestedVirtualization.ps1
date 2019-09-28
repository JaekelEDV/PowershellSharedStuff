#Nested Virtualization
$VMName = 'test'
#Machine has to be off
Stop-VM -Name $VMName
#Make it believe it has virtualization capabilities
Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
#Dynamic Memory has to be disabled
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
#MAC-Address Spoofing has to be on
Get-VMNetworkAdapter -VMName $VMName | select MacAddressSpoofing
Get-VMNetworkAdapter -VMName $VMName | Set-VMNetworkAdapter -MacAddressSpoofing On
#Bring back the VM
Start-VM -Name $VMName
#Inside the VM install the Hyper-V-Role
Add-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools
