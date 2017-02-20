# We'll use some well known CRAN libraries for this example
# mlbench: Use the builtin standard UCI breast cancer dataset
# caret: Use builtin function to create train and test datasets from a single dataset
# dplyr: Select specific columns from the dataframe

# First check to see if these packages are installed on this machine
if('mlbench' %in% rownames(installed.packages()) == FALSE) {install.packages('mlbench', repos='https://cran.r-project.org')}
if('caret' %in% rownames(installed.packages()) == FALSE) {install.packages('caret', repos='https://cran.r-project.org')}
if('dplyr' %in% rownames(installed.packages()) == FALSE) {install.packages('dplyr', repos='https://cran.r-project.org')}

# Load the libraries
library(mlbench)
library(caret)
library(dplyr)

# Load the MicrosoftML library
library(MicrosoftML)

# Load the breast cancer dataset in the mlbench library
data(BreastCancer)

# Examine the data
head(BreastCancer)
summary(BreastCancer)

# Since the label column (Class) is text, and the ML algorithm can train only
# on numeric labels, create a new Label column such that:
# benign <- 0, malignant <- 1
BreastCancer$Label[BreastCancer$Class == "benign"] <- 0
BreastCancer$Label[BreastCancer$Class == "malignant"] <- 1

# We don't need the Id and Class columns, so let's drop them
breastCancerDS <- select(BreastCancer, -Id, -Class)

# Partition the dataset 75%/25% split in order to create a train and test dataset
bCDS <- createDataPartition(y = breastCancerDS$Label, p = .75,  list = FALSE)

# Get the train and test dataset
trainDS <- breastCancerDS[bCDS, ] # This gives us the 75%
testDS <- breastCancerDS[-bCDS, ] # This gives us the remaining 25%

# Now train using rxFastLinear
# We'll use default parameters
# NOTE: One of the cool things about rxFastLinear is that L1 and L2 are automagically determined
# NOTE: from the training dataset
model <- rxFastLinear(formula = Label ~ ., data = trainDS)

# Let's evaluate the model using the test dataset
score <- rxPredict(model, data = testDS, extraVarsToWrite = "Label")

head(score)

# Let's look at the AUC and ROC
rxRocCurve(actualVarName = "Label", predVarNames = "Probability.1", data = score)

