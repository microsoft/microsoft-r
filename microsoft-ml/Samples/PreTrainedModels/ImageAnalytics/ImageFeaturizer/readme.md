# Image Featurizer Samples

## What is Image Featurization

Image featurization is the process by which given an image as input, a numeric vector (aka feature vector) that represents key characteristics (features) of that image is produced. The extraction of the features is done via an image featurizer that uses a pretrained Deep Neural Net model. 

Image featurization here is accomplished by using sophisticated DNN (Deep Neural Net) models that had already been pretrained on millions of images. As of this writing, we support 4 types of image featurization pretrained models:
1. Resnet-18
1. Resnet-50
1. Resnet-110
1. Alexnet

Each model has its own set of strengths and weaknesses. The user will need to try each of these models on which would fit best in their scenario.

The sample code here shows how to use these models.

## How can Image Featurization be used

We showcase 2 common usage scenarios of the pretrained image featurization model.
1. **Finding similar images**: Say you had a catalog of images. Then, given an input image, find out all the images in the catalog that are most similar to the given image. This scenario is the most straightforward scenario but may not be relevant to all scenarios.

2. **Training a custom model**: This scenario is especially useful when there's need to train an image analytics model that is very specific to some problem domain. In such a scenario, the feature vector from training images is used to train another machine learning model.

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

There  are 5 key APIs at play here. 4 of these APIs are values to the **mlTransforms** parameter while the 5th API is **rxFeaturize()**. We'll describe what each API does, in the order its used.
1. **loadImage()**: This API is used to load the image into the image featurization pipeline. In this specific example, we're telling the API to use the value in the Image column of the dataframe specified for the **data** parameter. And then, to name the resulting internal representation as "Features".
1. **resizeImage()**: As mentioned previously, currently 4 pretrained models are supported. Each of these models require the image they process to be of a certain dimension. Eg. the Resnet models require the image to be 224x224 pixels in dimension. While the Alexnet model requires the image to be 227x227 pixels. The resizeImage() API therefore ensures that irrespective of the original dimensions of the input image(s), that they get resized to the dimensions required by the model.
1. **extractPixels()**: This API extracts the pixels from the input, and by now resized image.
1. **featurizeImage()**: At this point, the image has been loaded, resized to the correct proportions, and the pixels extracted. The feaurizeImage() API is the one that now runs that data through the DNN pretrained model. The result set of this API is still in an internal format.
1. **rxFeaturize()**: rxFeaturize() takes the results from featurizeImage() and formats it into a dataframe and returns that dataframe. That dataframe now contains the feature vector of the original set of images.

### Sample pre-requisites

There is a section of code in the samples to make sure that the working directory is setup correctly. If this is not done right, the samples will not work correctly. Specifically, if the image featurizer does not find the images to featurize, then the samples will fail to run correctly.

```R
## TODO!! 
## Change NA to the actual location of the script. Use the absolute path.
workingDir <- NA
```
Change **NA** to the full path of your working directory first.

If you forget to change **NA** to a relevant path, then this code will throw an error.

```R
if (is.na(workingDir)){
  stop("Please make sure to set the working directory correctly. It should be the location of the script.")
}

# Check if the working directory exists
if (dir.exists(workingDir)){
  setwd(workingDir) 
} else {
  stop(paste(workingDir, "does not exist. Please make sure the working directory is correct."))
}
```

### Sample1: Finding similar images
The basic scenario of this sample is as follows. You have a catalog of images in your repository. As you get a new image, you want to find out from your catalog the closet match to this new image.

The way you'd go about this is via the following steps:
- Get the corresponding feature vectors of the images in the catalog and associate them with the source images in the catalog.
- Get the feature vector of the new image.
- Find out which image or set of images from the catalog has the smallest "distance" from the new image. There are a number of ways to calculate this distance. A simple one is the Euclidean distance, that we'll show in this sample.

In this sample, our intial catalog is a set of pictures of fish and helicopters. So let's go ahead and get the corresponding feature vectors of these catalog images.

First we'll create a dataframe with the location of these images:

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

Now let's get the corresponding feature vector of the catalog images into a dataframe:

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

Now let's get the feature vector of the new image:

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

So, at this point we have 2 sets of feature vectors: **imageFeatureVectorDF** contains the feature vector of the catalog images; **imageToMatchDF** contains the feature vector of the new vector.

The next step now is to find an image from the catalog that matches the new image. We'll use R's builtin **dist()** function to help us calculate the Euclidean distance between all these image feature vectors.

```R  
# Next we'll calculate the Euclidean distance between the image and all the other images
# We ignore the 1st column which is the image path
distVals <- dist(rbind(imageFeatureVectorDF, imageToMatchDF)[,-1], "euclidean")
```

Since the 1st column of the dataframe is the image location, we ignore the first column ```[,-1]```.

Now, the resultset distVals looks like this:

Distance With | 1 | 2 | 3 | 4 
--|---|---|---|---
2 | 104.80410 | NA | NA | NA                             
3 | 123.43032 | 121.90341 | NA | NA                  
4 | 26.98798 | 130.63937 | 74.19111 | NA          
5 | 112.88821 | 113.06911 | 120.94154 | 127.79847

Row 5 is the 5th image, that is the new image that we want matched against.
(NOTE: The actual values can change depending on the machine its run on, but the relationship between the values should be the same)

So this code extracts that row and finds the minimum value, ie smallest distance. Thereby indicating which image from the catalog matches the new image:

```R
# Here's the euclidean distance between the image of interest and the
# set to be matched against
i <- attr(distVals, "Size")
eucDist <- as.matrix(distVals)[i, -i]

# Let's get the closest match
# ie the image with the smallest Euclidean distance from 
# our image of interest
matchedImage <- imageDF[which.min(eucDist),]
cat(paste("The closest matching image is: ", matchedImage))
```

And the result will look as so:

```R
The closest matching image is:  Data/Pictures/Fish/Fish1.jpg
```

### Sample2: Train a custom image recognition model

In this sample, we'll train a model to classify the type of an image by training a model using the feature vector of images from a training set.

The method for obtaining the feature vectors of the images is exactly the same as the previous sample, so we won't go through those here.

In this sample, we'll train a multiclass linear model to distinguish between fish, helicopter and fighter jet images. So to the dataframe containing the location of the training images, we'll add a Type column and a numeric Label column to indicate the class of the image.

```R
# Let's add the image type
imagesDF$Type <- c("Fish","Fish","Fish","Fish","Fish",
                   "Helicopter","Helicopter","Helicopter","Helicopter","Helicopter",
                   "FighterJet","FighterJet","FighterJet","FighterJet","FighterJet")

# Now since we're going to train on these images, we need to have a label
# for each type that is a numeric value
imagesDF$Label[imagesDF$Type == "Fish"] <- 0
imagesDF$Label[imagesDF$Type == "Helicopter"] <- 1
imagesDF$Label[imagesDF$Type == "FighterJet"] <- 2
```

Now let's traing a multiclass classifier using the **rxLogisticRegression** algorithm. Just for kicks, and to compare from the previous sample, we'll use the Resnet-50 model.

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

Now let's give it an image to classify. Note that this image was not part of the original training set. See the actual code for details.

```R
imageFile <- c(file.path(imageLocation, "FighterJet/FighterJet6.jpg"))
```

Now that we have the model, and after getting the feature vector of the image we want to classify, let's predict the type of the image.

```R
# Let's use the trained model to predict the type of image
prediction <- rxPredict(imageModel, data = imageToMatch, extraVarsToWrite = list("Label", "Image"))

# And the type of image is?
typeOfImage <- imagesDF$Type[which(imagesDF$Label == prediction$PredictedLabel)[[1]]]
cat(paste("The image is of type: ", typeOfImage))
```

And the result is?

```R
The image is of type:  FighterJet
```
