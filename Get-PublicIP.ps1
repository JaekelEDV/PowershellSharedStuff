#requires -Version 3.0
Function Get-PublicIP {
  Invoke-RestMethod -Uri http://ipinfo.io/json | Select-Object #-ExpandProperty 'ip' 
}