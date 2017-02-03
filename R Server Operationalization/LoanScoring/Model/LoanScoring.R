#Remote Execution and Web Services for R Server
library(mrsdeploy)
help(mrsdeploy)

# Read from csv file and create your model
loans <- read.csv("https://raw.githubusercontent.com/Prabhat-MSFT/LoanScoring/master/Data/SampleLoanData.csv")
head(loans, 5)

# Train the model
idx <- runif(nrow(loans)) > 0.75
train <- loans[idx == FALSE,]

loanDataModel <- rxDForest(is_bad ~ revol_util + loan_amnt + int_rate + mths_since_last_record + annual_inc_joint + dti_joint + total_rec_prncp + all_util, train)

# Scoring Function
loanPredictService <- function(revol_util, int_rate, loan_amnt, mths_since_last_record, annual_inc_joint, dti_joint, total_rec_prncp, all_util) {
  inputData <- data.frame(revol_util = revol_util, loan_amnt = loan_amnt,int_rate = int_rate, mths_since_last_record = mths_since_last_record, annual_inc_joint = annual_inc_joint, dti_joint = dti_joint, total_rec_prncp = total_rec_prncp, all_util = all_util)
  prediction <- rxPredict(loanDataModel, inputData)
  loanScore <- prediction$is_bad_Pred 
}
remoteLogout()
remoteLogin("http://[RSERVERIP]:12800", session = TRUE, diff = TRUE, commandline =  TRUE, 
            prompt = "REMOTE_TECHREADY>>>", username = "", password = "")

pause()

service_name <- "loanPredictService1484942117"

# Publish service
api <- publishService(
  service_name,
  code = loanPredictService,
  model = loanDataModel,
  inputs = list(revol_util = 'numeric', loan_amnt = 'numeric', int_rate = 'numeric', mths_since_last_record = 'numeric', annual_inc_joint = 'numeric', dti_joint = 'numeric', total_rec_prncp = 'numeric', all_util = 'numeric'),
  outputs = list(loanScore = 'numeric'),
  v = 'v1.0.0'
)


# Show API capabilities
api$capabilities()

#Consume the service
loanScore <- api$loanPredictService(1, 1, 1, 1, 1, 1, 1,1)

loanScore$output("loanScore")

#List all services
services <- listServices()
services

#Generate swagger json file
cat(api$swagger(), file = "[SWAGGER_FILE_PATH]")

cap <- api$capabilities()
cap
cap$swagger
