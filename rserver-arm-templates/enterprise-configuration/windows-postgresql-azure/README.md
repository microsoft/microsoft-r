# Configuring R Server to operationalize analytics (Enterprise Configuration) (Windows)

<<<<<<< HEAD
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-azure%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-azure%2Fazuredeploy.json" target="_blank">
=======
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-postgresql-azure%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-postgresql-azure%2Fazuredeploy.json" target="_blank">
>>>>>>> origin/master
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configure-enterprise)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 


## Architecture
<<<<<<< HEAD
![Windows-Sql-Azure Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/windows-sql-azure/windows-postgresql-azure-architecture.png)
=======
![Windows-Sql-Azure Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/windows-postgresql-azure/windows-postgresql-azure-architecture.png)
>>>>>>> origin/master

## Setup HTTPS
It is highly recommended to use encrypt traffic to your Microsoft R Server cluster, especially if you use it in a production environment.

### Steps to setup HTTPS

[Configure an application gateway for SSL offload by using the portal](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-portal)

In "AppGateway" , Go to 'Listeners'

Add new listener, set protocol to 'HTTPS', upload your .pfx

Go to rules, change 'rule1' to use the Listener 'HTTPS' instead of 'HTTP'

Sample Powershell code to generate .pfx (replace <certname> and <password> with your choice)

```
$certFolder = "C:\certificates"
$certFilePath = "$certFolder\certFile.pfx"
$certStartDate = (Get-Date).Date
$certEndDate = $certStartDate.AddYears(10)
$certName = "<certname>"
$certPassword = "<certPassword>"
$certPasswordSecureString = ConvertTo-SecureString $certPassword -AsPlainText -Force
mkdir $certFolder
$cert = New-SelfSignedCertificate -DnsName $certName -CertStoreLocation cert:\CurrentUser\My -KeySpec KeyExchange -NotAfter $certEndDate -NotBefore $certStartDate
$certThumbprint = $cert.Thumbprint
$cert = (Get-ChildItem -Path cert:\CurrentUser\My\$certThumbprint)
Export-PfxCertificate -Cert $cert -FilePath $certFilePath -Password $certPasswordSecureString
```

## Connect to your cluster

Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 

**NOTE : adminPassword must be 8-16 characters long and contain at least 1 uppercase character(s), 1+ lowercase character(s), 1+ number(s), and 1+ special character(s).**

If you setup HTTPS:

Go to your Azure portal, from the list of resources that you just deployed, click "AppGateway", note down the 'Frontend Public IP Address'

```R
remoteLogin("https://<AppGatewayFrontendPublicIPaddress>",
             username = "<adminUsername>",
             password = "<adminPassword>")
```

Or, if you didn't setup HTTPS:

```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com",
             username = "<adminUsername>",
             password = "<adminPassword>")
```


For Example : 

If you setup HTTPS:

```R
remoteLogin("https://52.175.244.167",
             username = "azureuser",
             password = "Pa$$w0rd")
```

Or, if you didn't setup HTTPS:

```R
remoteLogin("http://o16ntest.eastus.cloudapp.azure.com",
             username = "azureuser",
             password = "Pa$$w0rd")
```

and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).

**NOTE : if Azure Active Directory is not used in the template, username is 'admin'.**

To connect to your cluster, use port 50000 for the first WebNode, 50001 for the second.

For example:

```R
mstsc /v:<dnsLabelPrefix>.<region>.cloudapp.azure.com:50000
<<<<<<< HEAD
```
=======
```
>>>>>>> origin/master
