# Configuring R Server to operationalize analytics (R Server on HDInsight Cluster v3.5)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fhdinsight%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png" />
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2Fmicrosoft-r%2Fmaster%2Frserver-arm-templates%2Fhdinsight%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template deploys a R Server on HDInsight cluster version 3.5 with edgenode as One-Box (Microsoft R Server 9.0)

Instructions to use R Server Operationalization are provided [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-r-server-get-started#using-microsoft-r-server-operationalization)

After setting up SSH tunnel using the above documentation, you can remoteLogin() using the following command : 

```R
remoteLogin("http://localhost:12800", username = "admin", password = "Microsoft@2017")
```

and start [Publishing Web Services](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/data-scientist-manage-services).

NOTE : Initial password for edgenode onebox is "Microsoft@2017". If you wish to change the password, ssh into the edgenode \<clustername\>-ed-ssh.azurehdinsight.net and [run Administrator Utility to update password](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/admin-utility#setupdate-local-administrator-password)
