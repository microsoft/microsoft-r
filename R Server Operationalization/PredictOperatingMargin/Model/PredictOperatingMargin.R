usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  library(p, character.only = TRUE)
}

usePackage("curl")
usePackage("ggplot2")
usePackage("mrsdeploy")

# Read data  
x <- read.csv(curl("https://raw.githubusercontent.com/Microsoft/microsoft-r/master/R%20Server%20Operationalization/PredictOperatingMargin/Data/TrainingData.csv"))
head(x,5)

# Create model  
myModel <- rxGlm(Margin ~ TotalRooms
                + NearestCompetition
                + AnnualVisitors
                + MedianIncome, data = x)


# Wrap model in a R function
CheckOperatingMargin <- function(i_totalrooms,i_nearestcompetition,i_annualvisitor,i_medianincome)
{
  myInput <- data.frame(TotalRooms = i_totalrooms,
                        NearestCompetition = i_nearestcompetition,
                        AnnualVisitors = i_annualvisitor,
                        MedianIncome = i_medianincome
  )
  
  prediction <- rxPredict(modelObject = myModel, data = myInput) 
  margin <- prediction$Margin_Pred
}

# Validate R function
print(CheckOperatingMargin(1000,5,500000, 75))

remoteLogout()
remoteLogin("http://[RSERVER IP]:12800", session = TRUE, diff = TRUE, commandline =  TRUE, 
            prompt = "REMOTE_TECHREADY>>>", username = "", password = "")
pause()

# Publish service
service_name <- "CheckLocationViabilityForHotel"
api <- publishService(
  service_name,
  code = CheckOperatingMargin,
  model = myModel,
  inputs = list(TotalRooms = 'numeric', NearestCompetition = 'numeric', AnnualVisitors = 'numeric', MedianIncome = 'numeric'),
  outputs = list(margin = 'numeric'),
  v = 'v1.0.0')

# Show API capabilities
api$capabilities()

#Consume the service
results <- api$CheckOperatingMargin(3400, 2, 50000, 75)
results$output("margin")

#List all services
services <- listServices()
services

#Generate swagger json file
cat(api$swagger(), file = "[SWAGGER_FILE_PATH]")
cap <- api$capabilities()
cap
cap$swagger


