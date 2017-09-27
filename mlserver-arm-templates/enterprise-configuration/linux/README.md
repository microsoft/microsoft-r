# Configuring Microsoft Machine Learning Server to operationalize analytics (Enterprise Configuration) (Linux)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Fmlserver-arm-templates%2Fenterprise-configuration%2Flinux%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Fmlserver-arm-templates%2Fenterprise-configuration%2Flinux%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


## Manage and configure Machine Learning Server for operationalization
[Manage and configure Machine Learning Server for operationalization](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/configure-start-for-administrators)


## How to Perform Enterprise Configuration
[Enterprise Configuration](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/configure-machine-learning-server-enterprise)


## Supported Platforms
[Supported Platforms](https://docs.microsoft.com/en-us/machine-learning-server/install/r-server-install-supported-platforms) 

## Architecture
![Linux-Sql-Azure Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/mlserver-arm-templates/enterprise-configuration/linux/linux-sql-azure-architecture.png)


## Connect to your cluster

Once you have deployed the cluster in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 

**NOTE : adminPassword must be 8-16 characters long and contain at least 1 uppercase character(s), 1+ lowercase character(s), 1+ number(s), and 1+ special character(s).**

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


and start [Publishing Web Services](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/quickstart-publish-r-web-service#b-publish-model-as-a-web-service).

**NOTE : if Azure Active Directory is not used in the template, username is 'admin'.**


To connect to your Linux virtual machine, you can SSH into its Public IP address. Use port 50000 for the first WebNode, 50001 for the second.

```
ssh <adminUsername>@<dnsLabelPrefix>.<region>.cloudapp.azure.com -p 50000
```
