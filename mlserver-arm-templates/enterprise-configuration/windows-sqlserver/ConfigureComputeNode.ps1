param (
    [string]$poolInitialSize,
    [string]$poolMaxSize
)

$appSettingsJson = Get-Content -Encoding UTF8 -Raw "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json" | ConvertFrom-Json
$appSettingsJson.Pool.InitialSize = [int32]::Parse($poolInitialSize)
$appSettingsJson.Pool.MaxSize = [int32]::Parse($poolMaxSize)
$appSettingsJson | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.ComputeNode\appsettings.json"

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd";
$psi.Arguments = "ml admin node setup --computenode";
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
