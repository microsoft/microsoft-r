# Configuring R Server to operationalize analytics (One-Box Configuration) (Windows)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fone-box-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fone-box-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>



## Setup and Configure R Server Operationalization 
[Configuring R Server for Operationalization](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)


## How to Perform One-Box Configuration
[One-Box Configuration](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial#how-to-perform-a-one-box-configuration)


Once you have deployed the One-Box in Azure, just install [Microsoft R Client](https://msdn.microsoft.com/en-us/microsoft-r/r-client-install-windows) and use the following code to remoteLogin() function in mrsdeploy package : 


```R
remoteLogin("http://<dnsLabelPrefix>.<region>.cloudapp.azure.com:12800", username = admin, password = <adminPassword>, session = FALSE)
```


and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).