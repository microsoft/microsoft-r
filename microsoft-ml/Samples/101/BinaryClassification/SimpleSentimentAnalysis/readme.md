# Sentiment Analysis using Text Featurizer

In this sample, we'll show a simple example on how to use the **featurizeText()** transform in the MicrosoftML package. 

You can find more information of the featurizeText() transform and other MicrosoftML APIs [here](https://msdn.microsoft.com/en-us/microsoft-r/microsoftml/microsoftml).

We'll use the [Sentiment Labelled Sentences](https://archive.ics.uci.edu/ml/datasets/Sentiment+Labelled+Sentences) dataset from the UCI repository. This dataset contains sentences labeled as positive or negative  sentiment.

For this sample we'll use the imdb_labelled.txt file as the training dataset, and the yelp_labelled.txt as the test dataset.

Since the [dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00331/sentiment%20labelled%20sentences.zip) is in a zip file, we'll need to unzip and extract the needed files. When we import the dataset, we'll add the column names **Text** and **Rating** to the dataset.

(**NOTE**: For offline use, you could also unzip the file yourself onto some local folder and use them that way. The sample code allows for both scenarios, with minor modifications to the code.)

The main steps are as follows:

1. [Load MicrosoftML package](#a-mmlload)
2. [Load the breast cancer dataset from mlbench](#a-dsload)
3. [Setup the featurizeText() transform](#a-trans)
5. [Train a model using rxFastLinear](#a-train)
6. [Predict using the test dataset](#a-test)
7. [Evaluate the performance of the model](#a-eval)

---
## <a name="a-mmlload"></a>1. Load MicrosoftML package
```
# Load the MicrosoftML library
library(MicrosoftML)
```

---
## <a name="a-dsload"></a>2. Load the training dataset
Note that we have some extra code here to get the datasets directly from UCI (online) or local (offline).

```
unZip <- TRUE # Set to FALSE if reading directly from the trainFile and testFile
trainFile = "sentiment labelled sentences/imdb_labelled.txt"
testFile = "sentiment labelled sentences/yelp_labelled.txt"

if (unZip) {
  # So get a local temp location
  temp <- tempfile()
  
  # Download the zip file to the temp location
  zipfile <- download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00331/sentiment%20labelled%20sentences.zip",temp)
  
  # We'll use the imdb_labelled.txt file for training
  dataTrain <- getData(unZip = TRUE, temp, trainFile)
} else {
  dataTrain <- getData(trainFile)
}
```

---
## <a name="a-trans"></a>3. Setup the featurizeText() transform
For starters, we'll use the featurizeText() transform with defaults. Feel free to play around with the different transform parameters to see if you can get a better AUC result. To find out the parameters of the transform, use **?featurizeText** in your R interpreter window.

The **vars** parameter tells the transform which column(s) to featurzie on. In this case, it's the Text column.

```
# Now let's setup the text featurizer transform
# We'll use all defaults for now
textTransform = list(featurizeText(vars = c(Features = "Text")))
```

---
## <a name="a-train"></a>4.  Train a model using rxFastLinear 
Here we indicate to the **rxFastLinear** algorithm to use the text featurizer via the **textTransform** variable that was setup in Step 3. We'll use all default parameters for the rxFastLinear algorithm.

```
# Train a linear model on featurized text
# Using all defaults for rxFastLinear algo
model <- rxFastLinear(
  Rating ~ Features, 
  data = dataTrain,
  mlTransforms = textTransform
)
```

---
## <a name="a-test"></a>5. Test the model using the test dataset 
Now let's test the model. We'll use yelp_labelled.txt as the test dataset.

```
# Get the predictions based on the test dataset
score <- rxPredict(model, data = dataTest, extraVarsToWrite = c("Rating"))

# Let's look at the prediction
head(score)
```

---
## <a name="a-eval"></a>6. Evaluate the performance of the model
Finally, let's see how good the model was based on the test dataset.
```
# How good was the prediction?
rxRocCurve(actualVarName = "Rating", predVarNames = "Probability.1", data = score)
```
