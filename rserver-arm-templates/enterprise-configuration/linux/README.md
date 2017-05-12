# Configuring R Server to operationalize analytics (Enterprise Configuration) (Linux)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Flinux%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fenterprise-configuration%2Flinux%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configure-enterprise)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 

## Architecture
![Linux-Sql-Azure Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/linux/linux-sql-azure-architecture.png)


## Connect to your cluster

Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 


```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com",
             username = "<adminUsername>",
             password = "<adminPassword>")
```


For Example : 


```R
remoteLogin("http://o16ntest.eastus.cloudapp.azure.com",
             username = "azureuser",
             password = "Pa$$w0rd")
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).


To connect to your Linux virtual machine, you can SSH into its Public IP address. Use port 50000 for the first WebNode, 50001 for the second.

```
ssh <adminUsername>@<dnsLabelPrefix>.<region>.cloudapp.azure.com:50000
```
