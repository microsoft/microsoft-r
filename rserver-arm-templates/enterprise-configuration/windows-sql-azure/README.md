# Configuring R Server to operationalize analytics (Enterprise Configuration) (Windows)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-azure%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows-sql-azure%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configure-enterprise)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 


## Architecture
![Windows-Sql-Azure Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/windows-sql-azure/windows-sql-azure-architecture.png)

## Setup HTTPS
It is highly recommended to use encrypt traffic to your Microsoft R Server cluster, especially if you use it in a production environment.

### Steps to setup HTTPS
Go to your Azure portal

Go to 'Frontend Public IP Address', take a note of the DNS name (e.g. 4d307f24-dc38-4a5a-9c15-47f585e62ff3.cloudapp.net). Add a new DNS CNAME record on your dns server to point from your HTTPS domain to this address.

Go to 'Application Gateway'

Go to 'Listeners'

Add new listener, set protocol to 'HTTPS', upload your .pfx

Go to rules, change 'rule1' to use the Listener 'HTTPS' instead of 'HTTP'

## Connect to your cluster

Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 


```R
remoteLogin("https://<yourdomain>",
             username = "<username>",
             password = "<password>")
```

Or, if you didn't setup HTTPS:

```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com",
             username = "<username>",
             password = "<password>")
```



For Example : 

```R
remoteLogin("https://ml.contoso.com",
             username = "myuser",
             password = "myPa$$w0rd")
```

Or, if you didn't setup HTTPS:

```R
remoteLogin("http://mlcontoso.eastus.cloudapp.azure.com",
             username = "myuser",
             password = "myPa$$w0rd")
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).

NOTE : if Azure Active Directory is not used in the template, username is 'admin'. 

To connect to your cluster, use port 50000 for the first WebNode, 50001 for the second.

For example:

```R
mstsc /v:<dnsLabelPrefix>.<region>.cloudapp.azure.com:50000
```