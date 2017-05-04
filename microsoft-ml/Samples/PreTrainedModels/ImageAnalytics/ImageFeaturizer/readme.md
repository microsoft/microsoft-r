# Image Featurizer Samples

## What is Image Featurization

Image featurization is the process by which given an image as input, the image featurizer outputs a numeric vector (aka feature vector). The extraction of the features is done via a pretrained Deep Neural Net model. The feature vector represents key features or characteristics of the image represented as a vector (list) of numbers.

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

There is a section of common code between the 2 samples here dealing with making sure that the working directory is setup correctly. If this is not done right, the samples will not work correctly.

The first step therefore is to make sure that the working directory is setup correctly, and therefore the images used in the samples can be accessed correctly by the image featurization APIs.

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

### Sample2: Train a custom image recognition model
