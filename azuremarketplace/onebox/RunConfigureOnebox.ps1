param (
    [string]$script,
    [string]$username,
    [string]$password,
    [string]$oneboxpassword
)

$securepassword =  ConvertTo-SecureString "$password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$username", $securepassword)
Enable-PSRemoting -Force
Invoke-Command -FilePath $script -ArgumentList $oneboxpassword -Credential $credential -ComputerName $env:COMPUTERNAME
Disable-PSRemoting -Force -WarningAction SilentlyContinue
winrm delete winrm/config/listener?address=*+transport=HTTP
Stop-Service winrm
Set-Service -Name winrm -StartupType Disabled
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Value 0 -Type DWord