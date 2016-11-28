#12345678901234567890123456789012345678901234567890123456789012345678901
# Compare predicting customer churn using different MML learners.

# A end-to-end example of finding the best model for predicting churn in
# the retail arena.

#-----------------------------------------------------------------------
# Contents
#-----------------------------------------------------------------------
# 1. Load packages.
# 2. Import data.
# 3. Create the label.
# 4. Create the features.
# 5. Assemble the dataset.
# 6. Split the dataset into train and test data.
# 7. Define the model to be fit.
# 8. Fit the model using different learners.
# 9. Score the held-aside test data with the fit models.
# 10. Compare the performance of fit models.

#-----------------------------------------------------------------------
# 1. Load packages.
#-----------------------------------------------------------------------
if (!suppressPackageStartupMessages(require("MicrosoftML",
                                            quietly = TRUE,
                                            warn.conflicts = FALSE))) {
    stop("The MicrosoftML package does not seem to be installed, so this\n",
         "script cannot be run. If Microsoft R Server with MML is installed,\n",
         "you may need to switch the R engine option. In R Tools for Visual\n",
         "Studio, this option is under:\n",
         "\tR Tools -> Options -> R Engine.\n",
         "If Microsoft R Server with MML is not installed, you can download it\n",
         "from https://microsoft.sharepoint.com/teams/TLC/SitePages/MicrosoftML.aspx\n")
}

#-----------------------------------------------------------------------
# 2. Import data.
#-----------------------------------------------------------------------
# The directory containing data files.
dataDir <- file.path("Data")
# Verify that the data files exist.
if (!all(file.exists(file.path(dataDir,
                               c("Retail Churn Users.csv",
                                 "Retail Churn Activity.csv"))))) {
          #12345678901234567890123456789012345678901234567890123456789012345678901
    stop("The data files needed for running this script cannot be found.\n",
         "You may need to set R's working directory to the location of the Data\n",
         "directory. If Microsoft R Server with MML is not installed, you can\n",
         "download it from\n",
         "https://microsoft.sharepoint.com/teams/TLC/SitePages/MicrosoftML.aspx\n")
}
# The data chunk size.
rowsPerBlock <- 1000000
# Import the customer characteristics. Drop the constant-valued Gender
# and UserType columns.
dataCustomers <-
    rxImport(file.path(dataDir, "Retail Churn Users.csv"),
             varsToDrop = c("Gender", "UserType"),
             colInfo = list(UserId = list(type = "factor"),
                            Age = list(type = "factor"),
                            Address = list(type = "factor")),
             outFile = tempfile(fileext = ".xdf"),
             rowsPerRead = rowsPerBlock)
# The levels for UserId. This is used when importing customer activity.
UserId.levels <-
    rxGetVarInfo(dataCustomers, varsToKeep = "UserId")$UserId$levels
# Import the customer activity. Remove the Column 0 row count column,
# and remove the constant-valued Location and ProductCategory columns.
dataActivity <-
    rxImport(file.path(dataDir, "Retail Churn Activity.csv"),
             varsToDrop = c("Column 0", "Location", "ProductCategory"),
             colInfo = list(TransactionId = list(type = "factor"),
                            Timestamp = list(type = "character"),
                            UserId = list(type = "factor",
                                          levels = UserId.levels),
                            ItemId = list(type = "factor")),
             transforms = list(Timestamp = as.Date(Timestamp,
                                                   format = "%m/%d/%Y")),
             outFile = tempfile(fileext = ".xdf"),
             rowsPerRead = rowsPerBlock)

#-----------------------------------------------------------------------
# 3. Create the label.
#-----------------------------------------------------------------------
# The churn period is the next churnPeriod days. A customer has churned
# if their activity drops below churnThreshold in the churn period. Then
# the prediction of churn is made using statistics about customer
# activity from before the churn period.
churnThreshold <- 0
churnPeriod <- as.difftime(21, units = "days")
# The date range of the activity data.
activityRange <-
    rxSummary( ~ Timestamp, dataActivity,
              summaryStats = c("Max", "Min"))$sDataFrame
activityMin <- as.Date(activityRange$Min, origin = "1970-01-01")
activityMax <- as.Date(activityRange$Max, origin = "1970-01-01")
if (activityMax - activityMin < 2 * churnPeriod) {
    stop("The training data period should be at least two times longer than the\n",
         "churn period.")
}
# The start of the churn period.
churnPeriodStart <- activityMax - churnPeriod
# The activity data from the before the churn period.
prechurnActivity <-
    rxDataStep(dataActivity,
               rowSelection = Timestamp <= churnPeriodStart,
               transformObjects = list(churnPeriodStart = churnPeriodStart),
               outFile = tempfile(fileext = ".xdf"))
# The total activity per customer is the number of rows per UserId
# in the complete data activity.
totalActivityCounts <-
    rxCube( ~ UserId, dataActivity,
           outFile = tempfile(fileext = ".xdf"),
           rowsPerBlock = rowsPerBlock)
# The prechurn period activity per customer is the number of rows per
# UserId in the prechurn activity.
prechurnActivityCounts <-
    rxCube( ~ UserId, prechurnActivity,
           outFile = tempfile(fileext = ".xdf"),
           rowsPerBlock = rowsPerBlock)
# Merge these data to line the numbers up.
activityCounts <-
    rxMerge(totalActivityCounts, prechurnActivityCounts,
            matchVars = "UserId",
            newVarNames1 = c(Counts = "totalCounts"),
            newVarNames2 = c(Counts = "prechurnCounts"),
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
# Compute whether a customer is a churner.  A customer has churned if their
# activity drops below churnThreshold in the churn period.
dataLabel <-
    rxDataStep(activityCounts,
               transforms = list(Label =
                                    totalCounts - prechurnCounts <=
                                        churnThreshold),
               transformObjects = list(churnThreshold = churnThreshold),
               outFile = tempfile(fileext = ".xdf"))

#-----------------------------------------------------------------------
# 4. Create the features.
#-----------------------------------------------------------------------
# Create features from the activity variables Timestamp, Quantity,
# Value, TransactionId, and ItemId. NOTE: The TransactionId feature will
# be obtained from the prechurnActivityCounts table.
#-----------------------------------------------------------------------
# Timestamp features are the per-customer recency and mean days between
# transactions. Recency is the number of days between the first day of
# the churn period and the last transaction.
TimestampData <-
    rxDataStep(prechurnActivity, varsToKeep = c("UserId", "Timestamp"),
               maxRowsByCols = 2 * nrow(prechurnActivity))
TimestampFeaturesDf <-
    do.call(rbind,
            lapply(split(TimestampData,
                        TimestampData$UserId, drop = TRUE),
                   function(x) {
                       data.frame(UserId = x$UserId[1],
                                   Recency = churnPeriodStart -
                                               max(x$Timestamp),
                                   MeanDaysBetweenActivity =
                                   if (nrow(x) == 1) {
                                       0
                                   } else {
                                       mean(as.difftime(diff(sort(x$Timestamp)),
                                                           units = "days"))
                                   })
                   }))
TimestampFeatures <-
    rxImport(TimestampFeaturesDf,
             outFile = tempfile(fileext = ".xdf"),
             rowsPerRead = rowsPerBlock)
# Quantity features are the per-customer total and standard deviation.
QuantityFeatures <-
    rxSummary(Quantity ~ UserId, prechurnActivity,
              summaryStats = c("Sum", "StdDev"),
              byGroupOutFile = tempfile(fileext = ".xdf"),
              rowsPerBlock = rowsPerBlock)$categorical[[1]]
# Replace missing standard deviations with 0s.
QuantityFeatures <-
    rxDataStep(QuantityFeatures,
               transforms = list(Quantity_StdDev =
                                    ifelse(is.na(Quantity_StdDev),
                                           0, Quantity_StdDev)),
               outFile = tempfile(fileext = ".xdf"))
# Value features are the per-customer total and standard deviation.
ValueFeatures <-
    rxSummary(Value ~ UserId, prechurnActivity,
              summaryStats = c("Sum", "StdDev"),
              byGroupOutFile = tempfile(fileext = ".xdf"),
              rowsPerBlock = rowsPerBlock)$categorical[[1]]
# Replace missing standard deviations with 0s.
ValueFeatures <-
    rxDataStep(ValueFeatures,
               transforms = list(Value_StdDev =
                                    ifelse(is.na(Value_StdDev),
                                           0, Value_StdDev)),
               outFile = tempfile(fileext = ".xdf"))
# TranscationId features are the per-customer number of unique
# transactions. These data are in the prechurnActivityCounts table that
# was previously created.
# ItemId features are the per-customer number of unique items.
# First get the unique ItemId-UserId pairs.
ItemIdUserIdPairs <-
    rxSort(prechurnActivity, sortByVars = c("UserId", "ItemId"),
           removeDupKeys = TRUE, varsToKeep = c("UserId", "ItemId"),
           outFile = tempfile(fileext = ".xdf"))
# Then count the number of rows per UserId.
ItemIdFeature <-
    rxCube( ~ UserId, ItemIdUserIdPairs,
           outFile = tempfile(fileext = ".xdf"),
           rowsPerBlock = rowsPerBlock)
#-----------------------------------------------------------------------
# Merge the feature data by UserId
dataFeatures <-
    rxMerge(TimestampFeatures, QuantityFeatures, matchVars = "UserId",
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
dataFeatures <-
    rxMerge(dataFeatures, ValueFeatures, matchVars = "UserId",
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
dataFeatures <-
    rxMerge(dataFeatures, prechurnActivityCounts, matchVars = "UserId",
            newVarNames2 = c(Counts = "TransactionId_Counts"),
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
dataFeatures <-
    rxMerge(dataFeatures, ItemIdFeature, matchVars = "UserId",
            newVarNames2 = c(Counts = "ItemId_Counts"),
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
# Compute feature ratios.
dataFeatures <-
    rxDataStep(dataFeatures,
               transforms =
                   list(Quantity_per_TransactionId =
                            Quantity_Sum / TransactionId_Counts,
                        Quantity_per_ItemId =
                            Quantity_Sum / ItemId_Counts,
                        Value_per_TransactionId =
                            Value_Sum / TransactionId_Counts,
                        Value_per_ItemId =
                            Value_Sum / ItemId_Counts),
               outFile = tempfile(fileext = ".xdf"),
               rowsPerRead = rowsPerBlock)

#-----------------------------------------------------------------------
# 5. Assemble the dataset.
#-----------------------------------------------------------------------
# Merge the customer data, features, and label to form the dataset.
dataset <-
    rxMerge(dataCustomers, dataFeatures, matchVars = "UserId",
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)
dataset <-
    rxMerge(dataset, dataLabel, matchVars = "UserId",
            varsToKeep2 = c("UserId", "Label"),
            outFile = tempfile(fileext = ".xdf"),
            rowsPerOutputBlock = rowsPerBlock)

#-----------------------------------------------------------------------
# 6. Split the dataset into train and test data.
#-----------------------------------------------------------------------
# Set the random seed for reproducibility of randomness.
set.seed(4253, "L'Ecuyer-CMRG")
# Randomly split the data 80-20 between train and test sets.
dataProb <- c(Train = 0.8, Test = 0.2)
dataSplit <-
    rxSplit(dataset,
            splitByFactor = "splitVar",
            transforms = list(splitVar =
                                sample(dataFactor,
                                       size = .rxNumRows,
                                       replace = TRUE,
                                       prob = dataProb)),
            transformObjects =
                list(dataProb = dataProb,
                     dataFactor = factor(names(dataProb),
                                         levels = names(dataProb))),
            outFilesBase = tempfile())
# Name the train and test datasets.
dataTrain <- dataSplit[[1]]
dataTest <- dataSplit[[2]]

#-----------------------------------------------------------------------
# 7. Define the model to be fit.
#-----------------------------------------------------------------------
# The variables in the data.
allVars <- names(dataTrain)
# The other variables are the record's properties.
xVars <- setdiff(allVars, c("UserId", "Label", "splitVar"))
# The model is a formula that says that churners are to be
# identified using the other variables.
model <- formula(paste("Label ~", paste(xVars, collapse = " + ")))

#-----------------------------------------------------------------------
# 8. Fit the model using different learners.
#-----------------------------------------------------------------------
# Fit the model with logistic regression. This finds the variable
# weights that are most useful for predicting churning. The
# logisticRegression learner automatically adjusts the weights to select
# those variables that are most useful for making predictions.
logisticRegressionFit <- logisticRegression(model, data = dataTrain)
#-----------------------------------------------------------------------
# Fit the model with linear regression. This finds the variable
# weights that are most useful for predicting churning. The
# fastLinear learner automatically adjusts the weights to select
# those variables that are most useful for making predictions.
fastLinearFit <- fastLinear(model, data = dataTrain)
#-----------------------------------------------------------------------
# Fit the model with boosted trees. This finds the combinations of
# variables and threshold values that are useful for predicting churning.
# The fastTrees learner automatically builds a sequence of trees so that
# trees later in the sequence repair errors made by trees earlier in the
# sequence.
fastTreesFit <- fastTrees(model, data = dataTrain, randomSeed = 23648)
#-----------------------------------------------------------------------
# Fit the model with random forest. This finds the combinations of
# variables and threshold values that are useful for predicting churning.
# The fastForest learner automatically builds a set of trees whose
# combined predictions are better than the predictions of any one of the
# trees.
fastForestFit <- fastForest(model, data = dataTrain, randomSeed = 23648)
#-----------------------------------------------------------------------
# Fit the model with neural net. This finds the variable weights that
# are most useful for predicting churning. Neural net can excel when
# dealing with non-linear relationships between the variables.
neuralNetFit <- neuralNet(model, data = dataTrain)

#-----------------------------------------------------------------------
# 9. Score the held-aside test data with the fit models.
#-----------------------------------------------------------------------
# The scores are each test record's probability of being a churner. This
# combines each fit model's predictions and the label into one table
# for side-by-side plotting and comparison.
fitScores <-
    predict(logisticRegressionFit, dataTest, suffix = ".logisticRegression",
              extraVarsToWrite = names(dataTest),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    predict(fastLinearFit, fitScores, suffix = ".fastLinear",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    predict(fastTreesFit, fitScores, suffix = ".fastTrees",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    predict(fastForestFit, fitScores, suffix = ".fastForest",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    predict(neuralNetFit, fitScores, suffix = ".neuralNet",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))

#-----------------------------------------------------------------------
# 10. Compare the performance of fit models.
#-----------------------------------------------------------------------
# Compute the fit models's ROC curves.
fitRoc <-
    rxRoc("Label",
          paste("Probability",
                 c("logisticRegression", "fastLinear", "fastTrees",
                   "fastForest", "neuralNet"),
                 sep = "."),
          fitScores)
# Plot the ROC curves and report their AUCs.
plot(fitRoc)
# Create a named list of the fit models.
fitList <-
    list(logisticRegression = logisticRegressionFit,
         fastLinear = fastLinearFit,
         fastTrees = fastTreesFit,
         fastForest = fastForestFit,
         neuralNet = neuralNetFit)
# Compute the fit models's AUCs.
fitAuc <- rxAuc(fitRoc)
names(fitAuc) <- substring(names(fitAuc), nchar("Probability.") + 1)
# Find the name of the fit with the largest AUC.
bestFitName <- names(which.max(fitAuc))
# Select the fit model with the largest AUC.
bestFit <- fitList[[bestFitName]]
# Report the fit AUCs.
cat("Fit model AUCs:\n")
print(fitAuc, digits = 2)
# Report the best fit.
cat(paste0("Best fit model with ", bestFitName,
           ", AUC = ", signif(fitAuc[[bestFitName]], digits = 2),
           ".\n"))