# Configuring R Server to operationalize analytics (Enterprise Configuration) (Windows)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configure-enterprise)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 


## Setup HTTPS
It is highly recommended to use encrypt traffic to your Microsoft R Server cluster, especially if you use it in a production environment.

### Steps to setup HTTPS
Go to your Azure portal




Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 


```R
remoteLogin("https://<dnsLabelPrefix>.<region>.cloudapp.azure.com",
             username = "admin",
             password = "<adminPassword>")
```

Or, if you haven't setup HTTPS

```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com",
             username = "<username>",
             password = "<password>")
```



For Example : 

```R
remoteLogin("https://016ntest.eastus.cloudapp.azure.com",
             username = "admin",
             password = "Pa$$w0rd")
```

Or, if you haven't setup HTTPS

```R
remoteLogin("http://016ntest.eastus.cloudapp.azure.com",
             username = "myuser",
             password = "myPa$$w0rd")
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).

To connect to your Windows Server VM, you can remote desktop using its Public IP Address. 