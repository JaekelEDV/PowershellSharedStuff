#Convert to Base64
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('blubber'))
Ymx1YmJlcg==

#Convert from Base64:
[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('Ymx1YmJlcg=='))
blubber


function ConvertFromBase64String
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string] $Base64String
    )
    [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String("$Base64String"))
}

function ConvertToBase64String
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string] $UTF8String
    )
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$UTF8String"))
}
