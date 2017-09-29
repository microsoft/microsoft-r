param (
    [string]$mlserverbinary,
    [string]$poolInitialSize,
    [string]$poolMaxSize
)

Invoke-WebRequest -UseBasicParsing -Uri "$mlserverbinary" -OutFile ServerSetup.exe

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = ".\ServerSetup.exe";
$psi.Arguments = "/quiet /install /full /models";
$psi.WorkingDirectory = (Get-Item -Path ".\" -Verbose).FullName;
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();

$appSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json" | ConvertFrom-Json
$appSettingsJson.Pool.InitialSize = [int32]::Parse($poolInitialSize)
$appSettingsJson.Pool.MaxSize = [int32]::Parse($poolMaxSize)
$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json"

Start-Process "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe" -Wait -ArgumentList """C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.Utils.AdminUtil\Microsoft.MLServer.Utils.AdminUtil.dll"" -SilentComputeNodeInstall" -WorkingDirectory "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n" -RedirectStandardOutput out.txt -RedirectStandardError err.txt