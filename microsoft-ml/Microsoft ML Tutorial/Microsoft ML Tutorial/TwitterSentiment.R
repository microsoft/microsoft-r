#12345678901234567890123456789012345678901234567890123456789012345678901
# Compare predicting sentiment in text using different Microsoft ML learners.

# Contents
# 1. Load packages.
# 2. Import data.
# 3. Split the dataset into train and test data.
# 4. Define the model to be fit.
# 5. Fit the model using different learners.
# 6. Score the held-aside test data with the fit models.
# 7. Compare the performance of fit models.

#-----------------------------------------------------------------------
# 1. Load packages.
#-----------------------------------------------------------------------
if (!suppressPackageStartupMessages(require("MicrosoftML",
                                            quietly = TRUE,
                                            warn.conflicts = FALSE))) {
    stop("The MicrosoftML package does not seem to be installed, so this\n",
         "script cannot be run. If Microsoft R Server with Microsoft ML is installed,\n",
         "you may need to switch the R engine option. In R Tools for Visual\n",
         "Studio, this option is under:\n",
         "\tR Tools -> Options -> R Engine.\n",
         "If Microsoft R Server with Microsoft ML is not installed, you can\n",
         "download it from:\n",
         "https://microsoft.sharepoint.com/teams/TLC/SitePages/MicrosoftML.aspx\n")
}

#-----------------------------------------------------------------------
# 2. Import data.
#-----------------------------------------------------------------------
# The directory containing data files.
dataDir <- file.path("Data")
# Verify that the data file exists.
if (!file.exists(file.path(dataDir, "HappyOrSad.csv"))) {
    stop("The data files needed for running this script cannot be found.\n",
         "You may need to set R's working directory to the location of the Data\n",
         "directory.")
}
# The data chunk size.
rowsPerBlock <- 1000000
# Import the data. Define Label.
dataset <-
    rxImport(file.path(dataDir, "HappyOrSad.csv"),
             colInfo = list(features = list(type = "character",
                                            newName = "Text"),
                            label = list(type = "character",
                                         newName = "sentiment")),
             transforms = list(Label = sentiment == "happiness"),
             quotedDelimiters = TRUE,
             outFile = tempfile(fileext = ".xdf"),
             rowsPerRead = rowsPerBlock)

#-----------------------------------------------------------------------
# 3. Split the dataset into train and test data.
#-----------------------------------------------------------------------
# Set the random seed for reproducibility of randomness.
set.seed(2345, "L'Ecuyer-CMRG")
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
# 4. Define the model to be fit.
#-----------------------------------------------------------------------
# The variables in the data.
allVars <- names(dataTrain)
# The other variables are the record's properties.
xVars <- setdiff(allVars, c("sentiment", "Label", "splitVar"))
# The model is a formula that says that sentiments are to be identified
# using features, a stand-in for variables created on-the-fly from text
# by the text transform.
model <- formula(paste("Label ~ Features"))

#-----------------------------------------------------------------------
# 5. Fit the model using different learners.
#-----------------------------------------------------------------------
# Fit the model with logistic regression. This finds the variable
# weights that are most useful for predicting sentiment. The
# rxLogisticRegression learner automatically adjusts the weights to select
# those variables that are most useful for making rxPredictions.
rxLogisticRegressionFit <-
    rxLogisticRegression(model, data = dataTrain,
                         mlTransforms =
                            list(featurizeText(vars = c(Features = "Text")),
                                 selectFeatures(model, mutualInformation())))
#-----------------------------------------------------------------------
# Fit the model with linear regression. This finds the variable
# weights that are most useful for predicting sentiment. The
# rxFastLinear learner automatically adjusts the weights to select
# those variables that are most useful for making rxPredictions.
rxFastLinearFit <-
    rxFastLinear(model, data = dataTrain,
                 mlTransforms =
                    list(featurizeText(vars = c(Features = "Text")),
                         selectFeatures(model, mutualInformation())))
#-----------------------------------------------------------------------
# Fit the model with boosted trees. This finds the combinations of
# variables and threshold values that are useful for predicting sentiment.
# The rxFastTrees learner automatically builds a sequence of trees so that
# trees later in the sequence repair errors made by trees earlier in the
# sequence.
rxFastTreesFit <-
    rxFastTrees(model, data = dataTrain,
                mlTransforms =
                    list(featurizeText(vars = c(Features = "Text")),
                         selectFeatures(model, mutualInformation())),
                randomSeed = 23648)
#-----------------------------------------------------------------------
# Fit the model with random forest. This finds the combinations of
# variables and threshold values that are useful for predicting sentiment.
# The rxFastForest learner automatically builds a set of trees whose
# combined rxPredictions are better than the rxPredictions of any one of the
# trees.
rxFastForestFit <-
    rxFastForest(model, data = dataTrain,
                 mlTransforms =
                    list(featurizeText(vars = c(Features = "Text")),
                         selectFeatures(model, mutualInformation())),
                 randomSeed = 23648)
#-----------------------------------------------------------------------
# Fit the model with neural net. This finds the variable weights that
# are most useful for predicting sentiment. Neural net can excel when
# dealing with non-linear relationships between the variables.
rxNeuralNetFit <-
    rxNeuralNet(model, data = dataTrain,
                mlTransforms =
                    list(featurizeText(vars = c(Features = "Text")),
                         selectFeatures(model, mutualInformation())))

#-----------------------------------------------------------------------
# 6. Score the held-aside test data with the fit models.
#-----------------------------------------------------------------------
# The scores are each test record's probability of being a sentiment.
# This combines each fit model's rxPredictions and the label into one
# table for side-by-side plotting and comparison.
fitScores <-
    rxPredict(rxLogisticRegressionFit, dataTest, suffix = ".rxLogisticRegression",
              extraVarsToWrite = names(dataTest),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    rxPredict(rxFastLinearFit, fitScores, suffix = ".rxFastLinear",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    rxPredict(rxFastTreesFit, fitScores, suffix = ".rxFastTrees",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    rxPredict(rxFastForestFit, fitScores, suffix = ".rxFastForest",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))
fitScores <-
    rxPredict(rxNeuralNetFit, fitScores, suffix = ".rxNeuralNet",
              extraVarsToWrite = names(fitScores),
              outData = tempfile(fileext = ".xdf"))

#-----------------------------------------------------------------------
# 7. Compare the performance of fit models.
#-----------------------------------------------------------------------
# Compute the fit models's ROC curves.
fitRoc <-
    rxRoc("Label",
          paste("Probability",
                 c("rxLogisticRegression", "rxFastLinear", "rxFastTrees",
                   "rxFastForest", "rxNeuralNet"),
                 sep = "."),
          fitScores)
# Plot the ROC curves and report their AUCs.
plot(fitRoc)
# Create a named list of the fit models.
fitList <-
    list(rxLogisticRegression = rxLogisticRegressionFit,
         rxFastLinear = rxFastLinearFit,
         rxFastTrees = rxFastTreesFit,
         rxFastForest = rxFastForestFit,
         rxNeuralNet = rxNeuralNetFit)
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