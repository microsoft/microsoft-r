# Configuring Microsoft Machine Learning Server to operationalize analytics (One-Box Configuration) (Windows Data Science VM)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Fmlserver-arm-templates%2Fone-box-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Fmlserver-arm-templates%2Fone-box-configuration%2Fwindows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


## Manage and configure Machine Learning Server for operationalization
[Manage and configure Machine Learning Server for operationalization](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/configure-start-for-administrators)


## How to Perform One-Box Configuration
[One-Box Configuration](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/configure-machine-learning-server-one-box)


## Supported Platforms
[Supported Platforms](https://docs.microsoft.com/en-us/machine-learning-server/install/r-server-install-supported-platforms) 


## Architecture
![One-Box Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/mlserver-arm-templates/one-box-configuration/windows/setup-onebox.png)

Once you have deployed the One-Box in Azure, you can connect to it using remoteLogin() function in [mrsdeploy](https://msdn.microsoft.com/en-us/microsoft-r/mrsdeploy/mrsdeploy) package : 

**NOTE : adminPassword must be 8-16 characters long and contain at least 1 uppercase character(s), 1+ lowercase character(s), 1+ number(s), and 1+ special character(s) from ~!@#$%^&()-_+=|<.>\/;:,**

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


and start [Publishing Web Services](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/quickstart-publish-r-web-service#b-publish-model-as-a-web-service).


To connect to your Windows Server VM, you can remote desktop using its Public IP Address/DNS name. 

```
mstsc /v:<dnsLabelPrefix>.<region>.cloudapp.azure.com
```

## Python QuickStarts

https://blogs.msdn.microsoft.com/mlserver/2017/12/13/getting-started-with-python-web-services-using-machine-learning-server/

https://docs.microsoft.com/en-us/machine-learning-server/operationalize/python/quickstart-deploy-python-web-service

https://github.com/Microsoft/ML-Server-Python-Samples/blob/master/operationalize/Quickstart_Publish_Python_Web_Service.ipynb

https://github.com/Microsoft/ML-Server-Python-Samples/blob/master/operationalize/Explore_Consume_Python_Web_Services.ipynb
