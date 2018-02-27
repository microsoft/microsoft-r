param (
    [string]$password
)

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.cmd";
$psi.Arguments = "ml admin node setup --onebox --admin-password ""$password"" --confirm-password ""$password"""
$psi.WorkingDirectory = "C:\Program Files\Microsoft\ML Server";
$psi.UseShellExecute = $false
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();
