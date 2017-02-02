Flight Prediction Service
=========================

## Operationalize - Publish FlightPredictService
1. RServer_FlightPredictionDemo.R contains the R code for Flight Predict Service.
1. Azure Active Directory Authentication, Modify RServer_FlightPredictionDemo.R code section
	2. Modify remoteLoginAAD(
    	      "Your Server Address ",<br />
	       authuri = "Auth URI",<br />
	       tenantid = "Tenant Id",<br />
	       clientid = "Client Id",<br />
	       resource = "Resource Id",<br />
	       session = FALSE<br />
	       )<br />
1. WebNode Login, Modify RServer_FlightPredictionDemo.R code.
	2. Use remoteLogin functionality  <br />
		endpoint <- "Your Server Address" <br />
		remoteLogin(endpoint, session = FALSE, diff = FALSE) <br />
1. Execute the R script to publish the FlightPredict as a service.

## Consume Service
1. Sample VS 2015 Console Application shows how to consume FlightPredict service
1. Open Project in VS 2015
1. Modify AAD details or User and Pwd details
1. Build and Run
