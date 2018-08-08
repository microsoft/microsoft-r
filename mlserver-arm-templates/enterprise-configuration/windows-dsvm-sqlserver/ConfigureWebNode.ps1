param (
	[string]$password,
    [string]$sqlServerConnectionString
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
$appSettingsJson.Logging.LogLevel.Default = "Information"
$appSettingsJson.Logging.LogLevel.System = "Information"
$appSettingsJson.Logging.LogLevel.Microsoft = "Information"
$appSettingsJson.ConnectionStrings.sqlserver.Enabled = $True
$appSettingsJson.ConnectionStrings.sqlserver.Connection = $sqlServerConnectionString
$appSettingsJson.ConnectionStrings.defaultDb.Enabled = $False
$appSettingsJson.Authentication.JWTSigningCertificate.Enabled = $True
$appSettingsJson.Authentication.JWTSigningCertificate.SubjectName = "DC=Windows Azure CRP Certificate Generator"
$appSettingsJson.ComputeNodesConfiguration.Uris.Ranges = @("http://10.0.1.1-255:12805")

$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode\appsettings.json"

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd";
$psi.Arguments = "ml admin node setup --webnode --admin-password ""$password"" --confirm-password ""$password""";
$psi.WorkingDirectory = "C:\Program Files\Microsoft\ML Server";
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = [System.Diagnostics.Process]::Start($psi);
$poutput = $p.StandardOutput.ReadToEnd();
$perror = $p.StandardError.ReadToEnd();
$p.WaitForExit();
Write-Output $poutput
Write-Output $perror

taskkill /f /im dotnet.exe
Disable-ScheduledTask -TaskName "autostartwebnode"

echo "<configuration><system.webServer><security><requestFiltering><requestLimits maxAllowedContentLength=""4294967295""/></requestFiltering></security><handlers><add name=""aspNetCore"" path=""*"" verb=""*"" modules=""AspNetCoreModule"" resourceType=""Unspecified"" /></handlers><aspNetCore requestTimeout=""01:00:00"" processPath=""C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe"" arguments=""./Microsoft.MLServer.WebNode.dll"" stdoutLogEnabled=""true"" stdoutLogFile="".\logs\stdout"" forwardWindowsAuthToken=""false""><environmentVariables><environmentVariable name=""COMPlus_ReadyToRunExcludeList"" value=""System.Security.Cryptography.X509Certificates"" /></environmentVariables></aspNetCore></system.webServer></configuration>" > "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.WebNode\web.config"

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
$appPool | Set-ItemProperty -Name "startMode" -Value "alwaysrunning"
$appPool | Set-ItemProperty -Name "processModel.idleTimeout" -Value "0"
$appPool | Set-ItemProperty -Name "processModel.identityType" -Value "NetworkService"
Pop-Location

Push-Location IIS:\Sites\
Get-ChildItem | Remove-Item -Recurse -Confirm:$false
$iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:"} -physicalPath $directoryPath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName

Pop-Location
iisreset