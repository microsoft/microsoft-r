#12345678901234567890123456789012345678901234567890123456789012345678901
# Use deep neural networks to identify handwritten digits in images.

# This script shows how MML can be used to create deep convolutional
# neural networks that classify handwritten digits images that were
# obtained from the MNIST database as being one of the ten digits, 0-9.

# For more information about the MNIST database, please consult:
# https://en.wikipedia.org/wiki/MNIST_database

# For more information about neural networks, please consult:
# https://azure.microsoft.com/en-us/documentation/articles/machine-learning-azure-ml-netsharp-reference-guide
# IMPORTANT NOTE: As of this release, MML supports three kinds of
# connection bundles described in this reference guide: full,
# filtered, and convolutional.

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
# Verify that the data file exists.
if (!file.exists(file.path(dataDir, "MNIST.xdf"))) {
    stop("The data files needed for running this script cannot be found.\n",
         "You may need to set R's working directory to the location of the Data\n",
         "directory. If Microsoft R Server with MML is not installed, you can\n",
         "download it from\n",
         "https://microsoft.sharepoint.com/teams/TLC/SitePages/MicrosoftML.aspx\n")
}
# The imported MNIST dataset.
dataset <- RxXdfData(file.path(dataDir, "MNIST.xdf"))

#-----------------------------------------------------------------------
# 3. Split the dataset into train and test data.
#-----------------------------------------------------------------------
# Split the data between train and test sets reproducing LeCun's split.
dataSplit <-
    rxSplit(dataset,
            splitByFactor = "splitVar",
            outFilesBase = tempfile())
# Name the train and test datasets.
dataTrain <- dataSplit[[1]]
dataTest <- dataSplit[[2]]

#-----------------------------------------------------------------------
# 4. Define the model to be fit.
#-----------------------------------------------------------------------
# The variables in the data
allVars <- names(dataTrain)
# The image's pixel values.
xVars <- setdiff(allVars, c("Label", "splitVar"))
# The model is a formula that says that an image is to be classified
# using its pixel values.
model <- formula(paste("Label ~", paste(xVars, collapse = " + ")))

#-----------------------------------------------------------------------
# 5. Fit the model using different learners.
#-----------------------------------------------------------------------
# Fit the model with logisticRegression. This finds the variable weights that
# are most useful for classifying images. The logisticRegression learner
# automatically adjusts the weights to select those variables that are
# most useful for classification. Unlike the convolutional network
# approaches shown below, this logistic regression does not take into
# account the spatial relationships between the pixels of the images.
logisticRegressionFit <- logisticRegression(model, dataTrain, type = "multiClass")
#-----------------------------------------------------------------------
# Fit the model with neuralNet. This learns which neural network
# weights are needed to classify images as digits based on the pixel
# value variables. The 'numIterations' input says how many times the
# learners goes over the training data to find the correct weights.
#-----------------------------------------------------------------------
# TRY THIS: Double numIterations from 9 to 18 and see:
# 1. how much better the fit network gets at digit classification, and
# 2. how much longer the learner needs to fit the network.
#-----------------------------------------------------------------------
# COMPARE the neural network and the logistic regression:
# 1. How long did each take to fit?
# 2. What are their differences in accuracy, precision, and recall?
#-----------------------------------------------------------------------
# The definition of the convolutional neural network.
neuralNetFile <- file.path(dataDir, "MNIST.nn")
neuralNet <- readChar(neuralNetFile, file.info(neuralNetFile)$size)
neuralNetFit <- neuralNet(model, data = dataTrain,
                              type = "multiClass",
                              numIterations = 9,
                              netDefinition = neuralNet,
                              initWtsDiameter = 1.0,
                              normalize = "No")
#-----------------------------------------------------------------------
# Fit the model with neuralNet. This network is an approximation of
# LeNet-5, Yann LeCun's 1998 convolutional network. This network has
# seven layers, and alternates convolutions and subsampling. For more
# information, see http://yann.lecun.com/exdb/publis/pdf/lecun-98.pdf
#-----------------------------------------------------------------------
# TRY THIS: Increase numIterations until the fit LeCun-5 reaches 99%
# accuracy.
#-----------------------------------------------------------------------
# The definition of the LeCun-5 neural network.
leCunNetFile <- file.path(dataDir, "LeCun5.nn")
leCun5Net <- readChar(leCunNetFile, file.info(leCunNetFile)$size)
leCun5NetFit <- neuralNet(model, data = dataTrain,
                            type = "multiClass",
                            numIterations = 9,
                            netDefinition = leCun5Net,
                            initWtsDiameter = 1.0,
                            normalize = "No")

#-----------------------------------------------------------------------
# 6. Score the held-aside test data with the fit models.
#-----------------------------------------------------------------------
# The scores are each record's probability of being one of the ten
# digits. The predicted label correspond to the digit with the highest
# score. We combine each learner's predictions and the label into one
# Xdf.
logisticRegressionScores <-
    predict(logisticRegressionFit, dataTest, extraVarsToWrite = "Label",
              outData = tempfile(fileext = ".xdf"))
neuralNetScores <-
    predict(neuralNetFit, dataTest, extraVarsToWrite = "Label",
              outData = tempfile(fileext = ".xdf"))
leCun5NetScores <-
    predict(leCun5NetFit, dataTest, extraVarsToWrite = "Label",
              outData = tempfile(fileext = ".xdf"))

#-----------------------------------------------------------------------
# 7. Compare the performance of fit models.
#-----------------------------------------------------------------------
# Create square confusion tables. The entries of these tables count the
# number of images of a digit that were classified as being one of the
# ten digits. The entries on a table's main diagonal, stretching from
# the top-left corner to the bottom-right corner, count the number of
# images that were correctly classified. The row sums are the counts
# of the number of times each digit was in an image. The column sums
# are the counts of the number of times each digit was predicted.
confusionFormula <- ~ Label:PredictedLabel
logisticRegressionConfusion <-
    rxCrossTabs(confusionFormula, logisticRegressionScores, returnXtabs = TRUE)
neuralNetConfusion <-
    rxCrossTabs(confusionFormula, neuralNetScores, returnXtabs = TRUE)
leCun5NetConfusion <-
    rxCrossTabs(confusionFormula, leCun5NetScores, returnXtabs = TRUE)
# The accuracy of the fit models. This is the ratio of the number of
# correct classification of images as having a digit to the total
# number of images that were classified.
accuracy <-
    cbind(logisticRegression = sum(diag(logisticRegressionConfusion)) /
                             sum(logisticRegressionConfusion),
          neuralNet = sum(diag(neuralNetConfusion)) /
                             sum(neuralNetConfusion),
          leCun5Net = sum(diag(leCun5NetConfusion)) /
                             sum(leCun5NetConfusion))
rownames(accuracy) <- "Accuracy"
names(dimnames(accuracy)) <- c("", "Learner")
# The precision and recall of the fit model, by digit. For a given
# digit, the precision is the fraction of assignments of that digit to
# images that were correct. In contrast, the recall is the fraction of
# images of that digit that were correct assigned that digit.
precision <-
    rbind(logisticRegression = diag(logisticRegressionConfusion) /
                             colSums(logisticRegressionConfusion),
          neuralNet = diag(neuralNetConfusion) /
                             colSums(neuralNetConfusion),
          leCun5Net = diag(leCun5NetConfusion) /
                             colSums(leCun5NetConfusion))
names(dimnames(precision)) <- c("Learner", "Digit")
recall <-
    rbind(logisticRegression = diag(logisticRegressionConfusion) /
                             rowSums(logisticRegressionConfusion),
          neuralNet = diag(neuralNetConfusion) /
                             rowSums(neuralNetConfusion),
          leCun5Net = diag(leCun5NetConfusion) /
                            rowSums(leCun5NetConfusion))
names(dimnames(recall)) <- c("Learner", "Digit")
#-----------------------------------------------------------------------
# Report the results.
#-----------------------------------------------------------------------
# Print the fit models's accuracies, and their per digit precision and
# recall.
print(accuracy, digits = 3)
cat("Per digit precision:\n")
print(precision, digits = 3)
cat("Per digit recall:\n")
print(recall, digits = 3)
# Barplots showing side-by-side the per digit precision and recall
# achieved by the fit models on the test data.
barplot(recall,
        legend.text = TRUE, beside = TRUE,
        main = "Per Digit Recall",
        xlab = "Digit", ylab = "Recall", ylim = 0:1,
        args.legend = list(x = "bottomright"))
barplot(precision,
        legend.text = TRUE, beside = TRUE,
        main = "Per Digit Precision",
        xlab = "Digit", ylab = "Precision", ylim = 0:1,
        args.legend = list(x = "bottomright"))