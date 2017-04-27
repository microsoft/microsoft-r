<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$poolInitialSize,
    [string]$poolMaxSize
)

$appSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.ComputeNode\appsettings.json" | ConvertFrom-Json
$appSettingsJson.Pool.InitialSize = [int32]::Parse($poolInitialSize)
$appSettingsJson.Pool.MaxSize = [int32]::Parse($poolMaxSize)
$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.ComputeNode\appsettings.json"

Start-Process "C:\Program Files\dotnet\dotnet.exe" -Wait -ArgumentList """C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.Utils.AdminUtil\Microsoft.RServer.Utils.AdminUtil.dll"" -SilentComputeNodeInstall" -WorkingDirectory "C:\Program Files\Microsoft\R Server\R_SERVER\o16n" -RedirectStandardOutput out.txt -RedirectStandardError err.txt