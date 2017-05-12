# Configuring R Server to operationalize analytics (Enterprise Configuration) (Windows)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-always-on%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-always-on%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configure-enterprise)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 


## Architecture
![Windows-Sql-Always-On Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/windows-sql-always-on/windows-sql-always-on-architecture.png)


## SQL Always On Architecture 
[Configure Always On availability groups in Azure Virtual Machines automatically: Resource Manager](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-alwayson-availability-groups)


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


## Role Based Access Control
[Roles to control web service permissions](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/security-roles) is enabled. 

<adminUserName> will be an owner and belongs to the Owners group in Active Directory.

Apart from this default user , 3 new users : owner, contributor, reader belonging to 3 new groups : Owners, Contributors, Readers will be available for remoteLogin. 


If you setup HTTPS:

```R
remoteLogin("https://<AppGatewayFrontendPublicIPaddress>", username = "owner", password = "<adminPassword>")
remoteLogin("https://<AppGatewayFrontendPublicIPaddress>", username = "contributor", password = "<adminPassword>")
remoteLogin("https://<AppGatewayFrontendPublicIPaddress>", username = "reader", password = "<adminPassword>")
```

Or, if you didn't setup HTTPS:

```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com", username = "owner", password = "<adminPassword>")
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com", username = "contributor", password = "<adminPassword>")
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com", username = "reader", password = "<adminPassword>")
```


To connect to your cluster, use port 50000 for the first WebNode, 50001 for the second.

For example:

```
mstsc /v:<dnsPrefix>.<region>.cloudapp.azure.com:50000
```
