
##################################################################
#   Step 1: Create a scoring function                            #
##################################################################

# Load the predictive model  
logitModel <- readRDS('logitModel.rds')

# Create a list to pass the data colum info together with the model object
trainingData <- readRDS('trainingDF.rds')
colInfo <- rxCreateColInfo(trainingData)

modelInfo <- list(predictiveModel = logitModel, colInfo = colInfo)

# Wrap up the prediction to a function for easy consumption
flightPrediction <- function(flightData) {
    data <- rxImport(flightData, colInfo = modelInfo$colInfo)
    rxPredict(modelInfo$predictiveModel, data, type = "response")
}

# Test if the function works as expected
testData <- readRDS('testDF.rds')
flightPrediction(testData)

##################################################################
#   Step 2: Loginto R Server that hosts the web services         #
##################################################################

remoteLoginAAD(
     "https://deployr-dogfood.mrs.microsoft-tst.com",
     authuri = "https://login.windows.net",
     tenantid = "microsoft.com",
     clientid = "3955bff3-2ec2-4975-9068-28acf86a3b6f",
     resource = "b3b96d00-1c06-4b9d-a94f-06ecb71822b0",
     session = FALSE
   )

# Use this if you are not using AAD. This will show a prompt to enter user and password
# remoteLogin(endpoint, session = FALSE, diff = FALSE)

##################################################################
#   Step 3: Publish as a web service                             #
##################################################################

api <- publishService(
  "FlightPredictionService",
  code = flightPrediction,
  model = modelInfo,
  inputs = list(newflightdata = "data.frame"),
  outputs = list(answer = "data.frame"),
  v = "v3.5.5"
)

# check how to consume the service
api$capabilities()

# verify it right away in R!
result <- api$flightPrediction(testData)
print(result$output("answer"))


##################################################################
#   Generate a swagger doc for integration with apps             #
##################################################################
swagger <- api$swagger()
cat(swagger, file = "swagger.json", append = FALSE)


##################################################################
#   How other data scientists to consume this web servicepps     #
##################################################################

# Explore the published services
services <- listServices()
services

# Get the service
FlightPredictionService <- services[[4]]
FlightPredictionService

modelApi <- getService(FlightPredictionService$name, FlightPredictionService$version)

# Consume the service
newFlightData <- readRDS('scoreDF.rds')
result <- modelApi$flightPrediction(newFlightData)
print(result$output("answer")) 