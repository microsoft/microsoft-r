<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$password
)

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files\dotnet\dotnet.exe";
$psi.Arguments = """C:\Program Files\Microsoft\R Server\R_SERVER\o16n\Microsoft.RServer.Utils.AdminUtil\Microsoft.RServer.Utils.AdminUtil.dll"" -silentoneboxinstall ""$password""";
$psi.WorkingDirectory = "C:\Program Files\Microsoft\R Server\R_SERVER\o16n";
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();
