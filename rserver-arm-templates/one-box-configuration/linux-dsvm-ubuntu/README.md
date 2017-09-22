# Configuring R Server to operationalize analytics (One-Box Configuration) (Linux Data Science VM Ubuntu 16.04 LTS)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fone-box-configuration%2Flinux-dsvm-ubuntu%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fone-box-configuration%2Flinux-dsvm-ubuntu%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform One-Box Configuration
[One-Box Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial#how-to-perform-a-one-box-configuration)


## Supported Platforms
[Supported Platforms](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial?#supported-platforms) 


## Architecture
![One-Box Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/one-box-configuration/linux-dsvm-ubuntu/setup-onebox.png)


Once you have deployed the One-Box in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 

**NOTE : adminPassword must be 8-16 characters long and contain at least 1 uppercase character(s), 1+ lowercase character(s), 1+ number(s), and 1+ special character(s).**

```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com:12800",
             username = "admin",
             password = "<adminPassword>")
```


For Example : 

```R
remoteLogin("http://016ntest.eastus.cloudapp.azure.com:12800",
             username = "admin",
             password = "Pa$$w0rd")
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).


To connect to your Linux VM, you can SSH into its Public IP address.

```
ssh <adminUsername>@<dnsLabelPrefix>.<region>.cloudapp.azure.com
```