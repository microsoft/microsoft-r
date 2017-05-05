# Image Featurizer Samples

## What is Image Featurization

Image featurization is the process that takes an image as input and produces a numeric vector (aka feature vector) that represents key characteristics (features) of that image. The features are extracted with an image-featurizing transform that uses a pretrained Deep Neural Net model. 

Image featurization here is accomplished by using sophisticated DNN (Deep Neural Net) models that have already been pretrained on millions of images. Currently, we support four types of image featurization pretrained models:
1. Resnet-18
2. Resnet-50
3. Resnet-110
4. Alexnet

Each model has its own set of strengths and weaknesses. The user can experiment with each of these models to decide which of them best handles their scenario.

The sample code here shows how to use these models.

## How can Image Featurization be used

We showcase two common usage scenarios for the pretrained image featurization model:
1. **Find similar images**: Compare a specified image to a catalogue of images to determine which of the images in the catalog are similar to the image provided. 

2. **Train a custom model**: This scenario is especially useful when there's need to train an image analytics model that is very specific to a particular problem domain. In such a scenario, the feature vector from training images is used to train another machine learning model.

The code used to get a feature vector, given one or more images, is typically as follows:

```R
# Setup a dataframe with the path to the image
# MUST set the stringAsFactors to FALSE
imageDF <- data.frame(Image = images, stringsAsFactors = FALSE)

# Get the feature vectors of the images
imageFeatureVector <- rxFeaturize(
  data = imageDF,
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 227, height = 227),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "alexnet")   
  ))
```

There  are five key APIs at play here. Four of these APIs are input parameter values for the **mlTransforms**. The fifth API is **rxFeaturize()**. Here are brief descriptions of what each of these APIs does:
1. **loadImage()**: Loads the image into the image featurization pipeline. In this example, the code says use the value in the Image column of the dataframe specified for the **data** parameter and name the resulting internal representation "Features".
2. **resizeImage()**: Ensures that the images get resized to the dimensions required by the model used, irrespective of the original dimensions of the input images. Each of the four pretrained models supported requires an image that they process to be of a certain dimension. The Resnet models require, for exmple, that the image to be 224x224 pixels in dimension while the Alexnet model requires the image to be 227x227 pixels.
3. **extractPixels()**: Extracts the pixels from the resized image input.
4. **featurizeImage()**: Runs that data through the DNN pretrained model. At this point, the image has been loaded, resized to the correct proportions, and the pixels extracted. The result set of this API is still in an internal format.
5. **rxFeaturize()**: Formats the results from featurizeImage() into a dataframe and returns that dataframe. The dataframe returned contains the feature vector of the original set of images.

### Sample pre-requisites

There is a section of code in the samples that make sure the working directory is setup correctly. If this is not set up correctly, the samples will not execute. Specifically, if the image featurizer does not find the images to featurize, then the samples will fail to run correctly.

```R
## TODO!! 
## Change NA to the actual location of the script. Use the absolute path.
workingDir <- NA
```
Change **NA** in this code to the full (absolute) path of your working directory.

If you do not change **NA** to a valid path that locates the script, this code throws an error.

```R
if (is.na(workingDir)){
  stop("The working directory needs to be set to the location of the script.")
}

# Check if the working directory exists
if (dir.exists(workingDir)){
  setwd(workingDir) 
} else {
  stop(paste(workingDir, "does not exist. Please make sure the working directory is correct."))
}
```

### Sample1: Find similar images
Here is the scenario this sample addresses: You have a catalog of images in a repository. When you get a new image, you want to find the image from your catalog that most closely matches this new image.

The procedure for finding the best match has the following steps:
- Locate the images in the catalogue and get their feature vectors.
- Locate the new image and get its feature vector.
- Find out which image or set of images from the catalog has the smallest "distance" from the new image. There are a number of ways to calculate this distance. A simple one is the Euclidean distance, which we use in this sample.

In this sample, our intial catalog consists a set of pictures of fish and helicopters.

First, create a dataframe with the locations of these images:

```R
# Set the location of the images
imageLocation = "Data/Pictures"

# Specify paths to the images we want to featurize
images <- c(file.path(imageLocation, "Fish/Fish1.jpg"), 
            file.path(imageLocation, "Fish/Fish2.jpg"), 
            file.path(imageLocation, "Helicopter/Helicopter1.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter2.jpg"))

# Setup a dataframe with the path to the image
# MUST set the stringAsFactors to FALSE
imageDF <- data.frame(Image = images, stringsAsFactors = FALSE)
```

Then, get the corresponding feature vectors for each of the catalog images into a dataframe:

```R
# Get the feature vectors of the images
# This requires a 4 step process:
# 1. Load the image(s) via the loadImage() transform
# 2. Resize the image(s) to the size required by the image model 
#    (224x224 for resnet models, 227x227 for the alexnet model)
# 3. Extract the pixels from the resized image(s) using the extractPixel() transform
# 4. Finally, featurize the image(s) via the featurizeImage() transform
imageFeatureVectorDF <- rxFeaturize(
  data = imageDF,
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 227, height = 227),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "alexnet")   
  ))
```

Secondly, create a dataframe with the location of the new image to match and get its feature vector into a dataframe:

```R
# Now, given an image, the task is to find the best matching image 
# from the list of images we'd featurized above

# First featurize the image that we want to find matches for
# We start with creating a dataframe with the location of the image
imageToMatch <- data.frame(Image = c(file.path(imageLocation, "Fish/Fish4.jpg")), 
                           stringsAsFactors = FALSE)

# Now let's featurize this image we want to match
# We'll use the Alexnet model
imageToMatchDF <- rxFeaturize(
  data = imageToMatch,
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 227, height = 227),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "alexnet")   
  ))
```

Thirdly, compare the new image with the images in the catalogue to find the best match. 
We have 2 sets of feature vectors: 
- **imageFeatureVectorDF** contains the feature vectors for the catalog images; 
- **imageToMatchDF** contains the feature vector of the new image to be compared.

The best match is defined (for our purposes) as the image pair with the least Euclidean distance between their image feature vectors where one of the feature vectors is for the new image. We implement these calculations using R's builtin **dist()** function.

```R  
# Next we'll calculate the Euclidean distance between the image and all the other images
# We ignore the 1st column which is the image path
distVals <- dist(rbind(imageFeatureVectorDF, imageToMatchDF)[,-1], "euclidean")
```

Note that the first column of the dataframe is ignored since it is used to locate the images. This parameter ikn the **dist()** function encodes this instruction:

```[,-1]```

Now, the resultset **distVals** should look like this:

Distance With | 1 | 2 | 3 | 4 
--|---|---|---|---
2 | 104.80410 | NA | NA | NA                             
3 | 123.43032 | 121.90341 | NA | NA                  
4 | 26.98798 | 130.63937 | 74.19111 | NA          
5 | 112.88821 | 113.06911 | 120.94154 | 127.79847

Row 5 contains the feature vector distances between the new image and the other images in the catalogue.
(NOTE: The actual values can change slightly depending on the machine used to run the code, but the order relations between the distance values should be invarient.)

Finally, this code finds the image from the catalog that best matches the new image by extracting the minimum value (and so least feature vector distance) from the fifth row that contains the relevant comparisons with the new image to match.

```R
# Here's the euclidean distance between the image of interest and the
# set to be matched against.
i <- attr(distVals, "Size")
eucDist <- as.matrix(distVals)[i, -i]

# Let's get the closest match,
# ie the image with the smallest Euclidean distance from 
# our image of interest.
matchedImage <- imageDF[which.min(eucDist),]
cat(paste("The closest matching image is: ", matchedImage))
```

The output specifies the best match:

```R
The closest matching image is:  Data/Pictures/Fish/Fish1.jpg
```

### Sample2: Train a model to classify images 
Here is the scenario this sample addresses: train a model to classify or recognize the type of an image using labeled observations from a training set provided. Specifically, this sample trains a multiclass linear model using the **rxLogisticRegression** algorithm to distinguish between fish, helicopter and fighter jet images. The multiclass training task uses the feature vectors of the images from the training set to learn how to classify these images.

The procedure for training the model has the following steps:
- Locate the images to use in the training set and get their feature vectors.
- Label the images in the training set by type.
- Train a multiclass classifier using the **rxLogisticRegression** algorithm.
- Specify a new image not in the training set to classify and use the trained model to predict its type.

First, the method for obtaining the feature vectors of the images is exactly the same as provided for sample1 and so are not repeated here.

Secondly, add a **Type** column and a numeric **Label** column to indicate the class of the images in the training set.

```R
# Let's add the image type.
imagesDF$Type <- c("Fish","Fish","Fish","Fish","Fish",
                   "Helicopter","Helicopter","Helicopter","Helicopter","Helicopter",
                   "FighterJet","FighterJet","FighterJet","FighterJet","FighterJet")

# Now since we're going to train on these images, we need to have a label.
# for each type that is a numeric value
imagesDF$Label[imagesDF$Type == "Fish"] <- 0
imagesDF$Label[imagesDF$Type == "Helicopter"] <- 1
imagesDF$Label[imagesDF$Type == "FighterJet"] <- 2
```

Thirdly, train a multiclass classifier using the **rxLogisticRegression** algorithm. Just for kicks, and to compare from the previous sample, we'll use the Resnet-50 model.

```R
# Now let's train a multiclass model using the image set we have
# We'll use rxLogisticRegression
imageModel <- rxLogisticRegression(
  formula = Label~Features,
  data = imagesDF,
  type = "multiClass",
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 224, height = 224),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "resnet50")) 
)
```

Note that ```type = "multiClass"``` indicates that this is a multiclass training task.

Finally, let's give it an image and its feature vector to classify. Note that this image was not part of the original training set. See the actual code for details.

```R
imageFile <- c(file.path(imageLocation, "FighterJet/FighterJet6.jpg"))
```

Now use the model to predict the type of the image:

```R
# Let's use the trained model to predict the type of image.
prediction <- rxPredict(imageModel, data = imageToMatch, extraVarsToWrite = list("Label", "Image"))

# And the type of image is?
typeOfImage <- imagesDF$Type[which(imagesDF$Label == prediction$PredictedLabel)[[1]]]
cat(paste("The image is of type: ", typeOfImage))
```

The result is:

```R
The image is of type:  FighterJet
```
