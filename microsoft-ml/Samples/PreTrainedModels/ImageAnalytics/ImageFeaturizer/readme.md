# Image Featurizer Samples

## What is Image Featurization
Image featurization is the process by which given an image as input, the image featurizer outputs a numeric vector (aka feature vector). The extraction of the features is done via a pretrained Deep Neural Net model. The feature vector represents key features or characteristics of the image represented as a vector (list) of numbers.

## How can Image Featurization be used
We showcase 2 common usage scenarios of the pretrained image featurization model.
1. **Finding similar images**: Say you had a catalog of images. Then, given an input image, find out all the images in the catalog that are most similar to the given image. This scenario is the most straightforward scenario but may not be relevant to all scenarios.

2. **Training a custom model**: This scenario is especially useful when there's need to train an image analytics model that is very specific to some problem domain. In such a scenario, the feature vector from training images is used to train another machine learning model.

## Sample1: Finding similar images

## Sample2: Train a custom image recognition model