<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$password,
    [string]$mlserverbinary
)

Invoke-WebRequest -UseBasicParsing -Uri "$mlserverbinary" -OutFile ServerSetup.exe

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = ".\ServerSetup.exe";
$psi.Arguments = "/quiet /install /full /models";
$psi.WorkingDirectory = (Get-Item -Path ".\" -Verbose).FullName;
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();

$psi = New-Object System.Diagnostics.ProcessStartInfo;
$psi.FileName = "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\dotnet\dotnet.exe";
$psi.Arguments = """C:\Program Files\Microsoft\ML Server\R_SERVER\o16n\Microsoft.MLServer.Utils.AdminUtil\Microsoft.MLServer.Utils.AdminUtil.dll"" -silentoneboxinstall ""$password""";
$psi.WorkingDirectory = "C:\Program Files\Microsoft\ML Server\R_SERVER\o16n";
$p = [System.Diagnostics.Process]::Start($psi);
$p.WaitForExit();
