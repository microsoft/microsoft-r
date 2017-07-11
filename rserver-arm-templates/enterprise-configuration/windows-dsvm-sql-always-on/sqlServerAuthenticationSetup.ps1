param (
    [string]$username,
    [string]$password
)

$query = "USE [master]
GO
CREATE LOGIN [$username] WITH PASSWORD=N'$password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC master..sp_addsrvrolemember @loginame = N'$username', @rolename = N'sysadmin'
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO"

Invoke-Sqlcmd -Query $query -ServerInstance $env:computername

Restart-Service -Force MSSQLSERVER
