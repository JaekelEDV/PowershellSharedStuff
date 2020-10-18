#first copy folder NanoServer from Install-ISO to c:\NanoServer
#then Import-Module for the needed PS-cmdlets
Import-Module C:\NanoServer\NanoServerImageGenerator -Verbose

#Create vhdx for Nanoserver
$params = @{
    Edition        = Standard #or Datacenter
    DeploymentType = Guest #VM ('Host' for physical install)
    MediaPath      = C:\ #needed folder will be found automagically
    BasePath       = C:\NanoServer\NanoServer1 #subfolder for nanoserver
    TargetPath     = c:\NanoServer\NanoServer1\nanoserver1.vhdx #name vhdx
    ComputerName   = nanoserver1 #name VM
}
#this command creates nanoserver based on the wim-file
New-NanoServerImage @params
