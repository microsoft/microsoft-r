param (
    [string]$password,
    [string]$postgresqlConnectionString,
    [string]$aadTenant,
    [string]$aadClientId
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
$appSettingsJson.ConnectionStrings.postgresql.Enabled = $True
$appSettingsJson.ConnectionStrings.postgresql.Connection = $postgresqlConnectionString
$appSettingsJson.ConnectionStrings.defaultDb.Enabled = $False
$appSettingsJson.Authentication.JWTSigningCertificate.Enabled = $True
$appSettingsJson.Authentication.JWTSigningCertificate.SubjectName = "DC=Windows Azure CRP Certificate Generator"
$appSettingsJson.BackEndConfiguration.Uris | add-member -Name "Ranges" -value @("http://10.0.1.1-255:12805") -MemberType NoteProperty

if($aadTenant -ne "") {
    $appSettingsJson.Authentication.AzureActiveDirectory.Authority = "https://login.windows.net/" + $aadTenant
    $appSettingsJson.Authentication.AzureActiveDirectory.Audience = $aadClientId
    $appSettingsJson.Authentication.AzureActiveDirectory.Enabled = $True
}

$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.WebNode\appsettings.json"

Start-Process "C:\Program Files\dotnet\dotnet.exe" -Wait -ArgumentList """C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.Utils.AdminUtil\Microsoft.RServer.Utils.AdminUtil.dll"" -silentWebNodeInstall ""$password""" -WorkingDirectory "C:\Program Files\Microsoft\R Server\R_SERVER\o16n" -RedirectStandardOutput out.txt -RedirectStandardError err.txt

taskkill /f /im dotnet.exe
Disable-ScheduledTask -TaskName "autostartwebnode"

mkdir c:\ping
echo "" >> c:\ping\index.htm
echo "<configuration><system.webServer><handlers><remove name=""aspNetCore"" /></handlers></system.webServer></configuration>" > c:\ping\web.config

echo "<configuration><system.webServer><handlers><add name=""aspNetCore"" path=""*"" verb=""*"" modules=""AspNetCoreModule"" resourceType=""Unspecified"" /></handlers><aspNetCore requestTimeout=""01:00:00"" processPath=""dotnet"" arguments=""./Microsoft.RServer.WebNode.dll"" stdoutLogEnabled=""true"" stdoutLogFile="".\logs\stdout"" forwardWindowsAuthToken=""false""><environmentVariables><environmentVariable name=""COMPlus_ReadyToRunExcludeList"" value=""System.Security.Cryptography.X509Certificates"" /></environmentVariables></aspNetCore></system.webServer></configuration>" > "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.WebNode\web.config"

$hostingBundleDownloadJob = Start-Job {Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=844461" -OutFile "C:\WindowsAzure\HostingBundle.exe"}
Install-WindowsFeature -name Web-Server -IncludeManagementTools
$hostingBundleDownloadJob | Wait-Job
Start-Process "C:\WindowsAzure\HostingBundle.exe" "/quiet /install OPT_INSTALL_LTS_REDIST=0 OPT_INSTALL_FTS_REDIST=0" -Wait

Import-Module WebAdministration

$iisAppPoolName = "netcore"
$iisAppName = "MRS-WebNode"
$directoryPath = "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.WebNode"

Push-Location IIS:\AppPools\
$appPool = New-Item $iisAppPoolName
$appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value ""
$appPool | Set-ItemProperty -Name "processModel.identityType" -Value "NetworkService"
Pop-Location

Push-Location IIS:\Sites\
Get-ChildItem | Remove-Item -Recurse -Confirm:$false
$iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:"} -physicalPath $directoryPath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName

$virtualDirectoryName = 'ping'
$physicalPath = 'c:\ping'
$virtualDirectoryPath = "IIS:\Sites\$iisAppName\$virtualDirectoryName"

New-Item $virtualDirectoryPath -type VirtualDirectory -physicalPath $physicalPath

Pop-Location
iisreset