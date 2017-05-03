param (
    [string]$username,
    [string]$password
)

$searchBase = "CN=Users,DC=contoso,DC=com"
New-ADUser -Name "owner" -GivenName "owner" -AccountPassword(ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount
New-ADUser -Name "contributor" -GivenName "contributor" -AccountPassword(ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount
New-ADUser -Name "reader" -GivenName "reader" -AccountPassword(ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

New-ADGroup -Name "Owners" -GroupScope Global -Path $searchBase
New-ADGroup -Name "Contributors" -GroupScope Global -Path $searchBase
New-ADGroup -Name "Readers" -GroupScope Global -Path $searchBase

Get-ADGroup -SearchBase $searchBase -filter { name -like "Owners" } | Add-ADGroupMember -Members "CN=$($username),$searchBase"
Get-ADGroup -SearchBase $searchBase -filter { name -like "Owners" } | Add-ADGroupMember -Members "CN=owner,$searchBase"
Get-ADGroup -SearchBase $searchBase -filter { name -like "Contributors" } | Add-ADGroupMember -Members "CN=contributor,$searchBase"
Get-ADGroup -SearchBase $searchBase -filter { name -like "Readers" } | Add-ADGroupMember -Members "CN=reader,$searchBase"

Get-ADUser -Filter * -SearchBase $searchBase -Properties userPrincipalName | foreach { Set-ADUser $_ -UserPrincipalName $_.name}
