# Breast cancer prediction using rxFastLinear

In this starter sample, we'll use the well known Breast Cancer UCI dataset with MicrosoftML's **rxFastLinear** algorithm to build a model to predict breast cancer.

The machine learning task here is a binary classification problem. Where given characteristics of a cell mass, predict whether the mass is benign or malignant.

Get more information on MicrosoftML functions [here](https://msdn.microsoft.com/en-us/microsoft-r/microsoftml/microsoftml).

This sample consists of 8 steps. 
Steps 1 - 5 are typical data pre-processing steps.
Step 6 shows the use of the **rxFastLinear** MicrosoftML algorithm.
Step 7 uses a test dataset to evaluate the model.
Step 8 shows the performance characteristics of the model.

1. [Install helper CRAN packages](#a-install)
2. [Load MicrosoftML package](#a-mmlload)
3. [Load the breast cancer dataset from mlbench](#a-dsload)
4. [Prep the dataset for use by MicrosoftML](#a-prep)
5. [Partition the dataset into train and test datasets using caret](#a-split)
6. [Train a model using rxFastLinear](#a-train)
7. [Predict using the test dataset](#a-test)
8. [Evaluate the performance of the model](#a-eval)

---
## <a name="a-install"></a>1. Install helper CRAN packages

```
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
```

---
## <a name="a-mmlload"></a>2. Load MicrosoftML package

```
# Load the MicrosoftML library
library(MicrosoftML)
```

---
## <a name="#a-dsload"></a>3. Load the breast cancer dataset from mlbench

```
# Load the breast cancer dataset in the mlbench library
data(BreastCancer)

# Examine the data
head(BreastCancer)
summary(BreastCancer)
```

---
## <a name="#a-prep"></a>4. Prep the dataset for use by MicrosoftML

```
# Since the label column (Class) is text, and the ML algorithm can train only
# on numeric labels, create a new Label column such that:
# benign <- 0, malignant <- 1
BreastCancer$Label[BreastCancer$Class == "benign"] <- 0
BreastCancer$Label[BreastCancer$Class == "malignant"] <- 1

# We don't need the Id and Class columns, so let's drop them
breastCancerDS <- select(BreastCancer, -Id, -Class)
```

---
## <a name="#a-split"></a>5. Partition the dataset into train and test datasets using caret

```
# Partition the dataset 75%/25% split in order to create a train and test dataset
bCDS <- createDataPartition(y = breastCancerDS$Label, p = .75,  list = FALSE)

# Get the train and test dataset
trainDS <- breastCancerDS[bCDS, ] # This gives us the 75%
testDS <- breastCancerDS[-bCDS, ] # This gives us the remaining 25%
```

---
## <a name="#a-train"></a>6. Train a model using rxFastLinear(#a-train)
Using the training dataset obtained from the previous step, we'll use the rxFastLinear MicrosoftML algorithm to train a model. 
A unique feature of the rxFastLinear is that the L1 and L2 regularization factors are automatically determined from the dataset.

```
# Now train using rxFastLinear
# We'll use default parameters
# NOTE: One of the cool things about rxFastLinear is that L1 and L2 are automagically determined
# NOTE: from the training dataset
model <- rxFastLinear(formula = Label ~ ., data = trainDS)
```

---
## <a name="#a-test"></a>7. Predict using the test dataset

```
# Let's evaluate the model using the test dataset
score <- rxPredict(model, data = testDS, extraVarsToWrite = "Label")

head(score)
```

---
## <a name="##a-eval"></a>8. Evaluate the performance of the model

```
# Let's look at the AUC and ROC
rxRocCurve(actualVarName = "Label", predVarNames = "Probability.1", data = score)
```
