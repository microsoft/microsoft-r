param (
	[string]$password,
    [string]$sqlServerConnectionString,
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

$computeNodeAppSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json" | ConvertFrom-Json
$computeNodeAppSettingsJson | add-member -Name "configured" -value "configured" -MemberType NoteProperty
$computeNodeAppSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json"

$appSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode\appsettings.json" | ConvertFrom-Json
$appSettingsJson.ConnectionStrings.sqlserver.Enabled = $True
$appSettingsJson.ConnectionStrings.sqlserver.Connection = $sqlServerConnectionString
$appSettingsJson.ConnectionStrings.defaultDb.Enabled = $False
$appSettingsJson.Authentication.JWTSigningCertificate.Enabled = $True
$appSettingsJson.Authentication.JWTSigningCertificate.SubjectName = "DC=Windows Azure CRP Certificate Generator"
$appSettingsJson.BackEndConfiguration.Uris | add-member -Name "Ranges" -value @("http://10.0.1.1-255:12805") -MemberType NoteProperty

if($aadTenant -ne "") {
    $appSettingsJson.Authentication.AzureActiveDirectory.Authority = "https://login.windows.net/" + $aadTenant
    $appSettingsJson.Authentication.AzureActiveDirectory.Audience = $aadClientId
    $appSettingsJson.Authentication.AzureActiveDirectory.Enabled = $True
}

$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode\appsettings.json"

Start-Process "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe" -Wait -ArgumentList """C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.Utils.AdminUtil\Microsoft.MLServer.Utils.AdminUtil.dll"" -silentWebNodeInstall ""$password""" -WorkingDirectory "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n" -RedirectStandardOutput out.txt -RedirectStandardError err.txt

taskkill /f /im dotnet.exe
Disable-ScheduledTask -TaskName "autostartwebnode"

echo "<configuration><system.webServer><handlers><add name=""aspNetCore"" path=""*"" verb=""*"" modules=""AspNetCoreModule"" resourceType=""Unspecified"" /></handlers><aspNetCore requestTimeout=""01:00:00"" processPath=""C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe"" arguments=""./Microsoft.MLServer.WebNode.dll"" stdoutLogEnabled=""true"" stdoutLogFile="".\logs\stdout"" forwardWindowsAuthToken=""false""><environmentVariables><environmentVariable name=""COMPlus_ReadyToRunExcludeList"" value=""System.Security.Cryptography.X509Certificates"" /></environmentVariables></aspNetCore></system.webServer></configuration>" > "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode\web.config"

$hostingBundleDownloadJob = Start-Job {Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=844461" -OutFile "C:\WindowsAzure\HostingBundle.exe"}
Install-WindowsFeature -name Web-Server -IncludeManagementTools
$hostingBundleDownloadJob | Wait-Job
Start-Process "C:\WindowsAzure\HostingBundle.exe" "/quiet /install OPT_INSTALL_LTS_REDIST=0 OPT_INSTALL_FTS_REDIST=0" -Wait

Import-Module WebAdministration

$iisAppPoolName = "netcore"
$iisAppName = "MLS-WebNode"
$directoryPath = "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode"

Push-Location IIS:\AppPools\
$appPool = New-Item $iisAppPoolName
$appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value ""
$appPool | Set-ItemProperty -Name "processModel.identityType" -Value "NetworkService"
Pop-Location

Push-Location IIS:\Sites\
Get-ChildItem | Remove-Item -Recurse -Confirm:$false
$iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:"} -physicalPath $directoryPath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName

Pop-Location
iisreset