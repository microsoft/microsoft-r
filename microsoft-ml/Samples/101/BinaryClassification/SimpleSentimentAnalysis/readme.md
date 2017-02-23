# Sentiment Analysis using Text Featurizer

In this sample, we'll show a simple example how to use the **featurizeText()** transform in the MicrosoftML package. 
You can find more information of the featurizeText() transform and other MicrosoftML APIs [here](https://msdn.microsoft.com/en-us/microsoft-r/microsoftml/microsoftml).

We'll use the [Sentiment Labelled Sentences](https://archive.ics.uci.edu/ml/datasets/Sentiment+Labelled+Sentences) dataset from the UCI repository. This dataset contains sentences labelled as positive or negative  sentiment.

Since the [dataset](https://archive.ics.uci.edu/ml/machine-learning-databases/00331/sentiment%20labelled%20sentences.zip) is in a zip file, we'll need to unzip and extract the needed files. For this sample we'll use the imdb_labelled.txt file as the training dataset, and the yelp_labelled.txt as the test dataset.
(**NOTE**: For offline use, you could also unzip the file yourself onto some local folder and use them that way. The sample code allows for both scenarios, with minor modifications to the code.)

The main steps are as follows:
1. [Load MicrosoftML package](#a-mmlload)
2. [Load the breast cancer dataset from mlbench](#a-dsload)
3. [Prep the dataset for use by MicrosoftML](#a-prep)
4. [Partition the dataset into train and test datasets using caret](#a-split)
5. [Train a model using rxFastLinear](#a-train)
6. [Predict using the test dataset](#a-test)
7. [Evaluate the performance of the model](#a-eval)

---
## <a name="a-mmlload"></a>1. Load MicrosoftML package
```
# Load the MicrosoftML library
library(MicrosoftML)
```