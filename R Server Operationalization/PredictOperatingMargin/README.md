
Predict Operating Margin
========================
Demo of Operating Margin app to predict operating margin of a hotel - includes R Models, sample data script and VS solution for an MVC app.

## Steps to use the code sample

1. Configure one box operationalization set up of R Server using the instructions at https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial. One box set up is simpler, though you can also try the enterprise set up. 

1. use  the IP of web node with port or the virtual IP (in case of Load balancer) to update remote login credentials in Model/PredictOperatingMargin.R file. 

    remoteLogin("http://[RSERVER IP]:12800", session = TRUE, diff = TRUE, commandline =  TRUE, prompt = "REMOTE_TECHREADY>>>", username =     "", password = "")
    
1. Update SWAGGER_FILE_PATH token in Model/PredictOperatingMargin.R to store SWAGGER DOC in a local file system. SWAGGER document relevant to the solution is checked-in at the top level of the file as HotelOperationgMargin.json
    
1. Run Model/PredictOperatingMargin.R in R Studio. This will publish the required service to the R Server in step 1.

1. Connect VS to this github repository to pull the code locally. Update the web.config to have correct web node URL:Port, User name and Password.

    <add key="WebNodeAddress" value="http://IPADDRESS:PORT"/>
    <add key="WebNodeUserName" value="USERNAME"/>
    <add key="WebNodePassword" value="PASSWORD"/>
    
1. Build and run.

1. Alternatively you can regenerate the client code via AUTOREST from the created SWAGGER document - please review the instructions here https://msdn.microsoft.com/en-us/microsoft-r/operationalize/app-developer-get-started. You can update the generated client code in the VS solution for any update.

1. Code is connected to AZURE, you can publish it to a app service within your subscription. 
