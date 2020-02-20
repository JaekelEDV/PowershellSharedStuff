Function Get-IPInfo {
  param (
    [Parameter(Mandatory=$true,Helpmessage='Enter a valid IP Address')]
    [string] $IP
  )
  Invoke-RestMethod -Uri http://ipinfo.io/$ip/json
}



  
