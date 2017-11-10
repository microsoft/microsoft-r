param (
    [string]$password
)

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe";
$psi.Arguments = """C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.Utils.AdminUtil\Microsoft.MLServer.Utils.AdminUtil.dll"" -silentoneboxinstall ""$password""";
$psi.WorkingDirectory = "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n";
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();
