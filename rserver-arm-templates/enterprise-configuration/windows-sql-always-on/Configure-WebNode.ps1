param (
    [string]$username,
    [string]$password
)

function AllowRead-Certificate
{
    param($cert)

	$rsaFileName = $cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

	$keyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\"
	$fullPath = $keyPath+$rsaFileName

	$acl = Get-Acl -Path $fullPath
	$networkService = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::NetworkServiceSid, $null)
	$permission=$networkService,"Read","Allow"
	$accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
	$acl.AddAccessRule($accessRule)

	Set-Acl $fullPath $acl
}

Push-Location Cert:\LocalMachine\My\
Get-ChildItem | where { $_.Subject -eq 'DC=Windows Azure CRP Certificate Generator' -And $_.HasPrivateKey -And ($_.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName -eq $Null) } | Remove-Item
$cert = (Get-ChildItem | where { $_.Subject -eq 'DC=Windows Azure CRP Certificate Generator' })[0]
Pop-Location

AllowRead-Certificate($cert)

$appSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.WebNode\appsettings.json" | ConvertFrom-Json
$appSettingsJson.Authentication.JWTSigningCertificate.Enabled = $True
$appSettingsJson.Authentication.JWTSigningCertificate.SubjectName = "DC=Windows Azure CRP Certificate Generator"
$appSettingsJson.ConnectionStrings.defaultDb.Enabled = $False
$appSettingsJson.ConnectionStrings.sqlserver.Enabled = $True
$appSettingsJson.ConnectionStrings.sqlserver.Connection = "Data Source=tcp:10.0.1.9,1433;Initial Catalog=RServerOperationalization;User Id='$username';Password='$password';"
$appSettingsJson.Authentication.LDAP.Enabled = $True
$appSettingsJson.Authentication.LDAP.Host = "10.0.0.4"
$appSettingsJson.Authentication.LDAP.QueryUserDn = "CN=$username,CN=Users,DC=contoso,DC=com"
$appSettingsJson.Authentication.LDAP.QueryUserPassword = "$password"
$appSettingsJson.Authentication.LDAP.SearchBase = "CN=Users,DC=contoso,DC=com"
$appSettingsJson.Authentication.LDAP.SearchFilter = "cn={0}"
$appSettingsJson.BackEndConfiguration.Uris | add-member -Name "Ranges" -value @("http://10.1.0.5:40000-40099") -MemberType NoteProperty
$appSettingsJson.Authorization | add-member -Name "Owner" -value @("Owners") -MemberType NoteProperty
$appSettingsJson.Authorization | add-member -Name "Contributor" -value @("Contributors") -MemberType NoteProperty
$appSettingsJson.Authorization | add-member -Name "Reader" -value @("Readers") -MemberType NoteProperty
$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.WebNode\appsettings.json"
Start-Process "C:\Program Files\dotnet\dotnet.exe" -Wait -ArgumentList """C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.Utils.AdminUtil\Microsoft.RServer.Utils.AdminUtil.dll"" -silentWebNodeInstall ""$password""" -WorkingDirectory "C:\Program Files\Microsoft\R Server\R_SERVER\o16n" -RedirectStandardOutput out.txt -RedirectStandardError err.txt