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
![Windows-On-Prem Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/enterprise-configuration/windows-sql-always-on/windows-on-prem-architecture.jpg)


## SQL Always On Architecture 
[Configure Always On availability groups in Azure Virtual Machines automatically: Resource Manager](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-alwayson-availability-groups)


## Connect to your cluster

Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 


```R
remoteLogin("http://<vmssName>.<region>.cloudapp.azure.com",
             username = "<adminUsername>",
             password = "<adminPassword>")
```


For Example : 

```R
remoteLogin("http://o16ntest.eastus.cloudapp.azure.com",
             username = "o16ntest",
             password = "Pa$$w0rd")
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).


## Role Based Access Control
[Roles to control web service permissions](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/security-roles) is enabled. 

<adminUserName> will be an owner and belongs to the Owners group in Active Directory.

Apart from this default user , 3 new users : owner, contributor, reader belonging to 3 new groups : Owners, Contributors, Readers will be available for remoteLogin. 


```R
remoteLogin("http://<vmssName>.<region>.cloudapp.azure.com", username = "owner", password = "<adminPassword>")
remoteLogin("http://<vmssName>.<region>.cloudapp.azure.com", username = "contributor", password = "<adminPassword>")
remoteLogin("http://<vmssName>.<region>.cloudapp.azure.com", username = "reader", password = "<adminPassword>")
```


To connect to your cluster, use port 50000 for the first WebNode, 50001 for the second.

For example:

```
mstsc /v:<vmssName>.<region>.cloudapp.azure.com:50000
```