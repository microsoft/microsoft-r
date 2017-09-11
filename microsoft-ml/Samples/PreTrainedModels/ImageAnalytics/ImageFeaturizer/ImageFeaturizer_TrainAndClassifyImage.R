source("utils.R")

# Set the working directory for this script

## TODO!! 
## Change NA to the actual location of the script. Use the absolute path.
workingDir <- NA

if (is.na(workingDir)){
  stop("Please make sure to set the working directory correctly. It should be the location of the script.")
}

# Check if the working directory exists
if (dir.exists(workingDir)){
  setwd(workingDir) 
} else {
  stop(paste(workingDir, "does not exist. Please make sure the working directory is correct."))
}

# Set the location of the images
imageLocation = "Data/Pictures"

# Specify paths to the images we want to featurize
images <- c(file.path(imageLocation, "Fish/Fish1.jpg"), 
            file.path(imageLocation, "Fish/Fish2.jpg"), 
            file.path(imageLocation, "Fish/Fish3.jpg"),
            file.path(imageLocation, "Fish/Fish4.jpg"),
            file.path(imageLocation, "Fish/Fish5.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter1.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter2.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter3.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter4.jpg"),
            file.path(imageLocation, "Helicopter/Helicopter5.jpg"),
            file.path(imageLocation, "FighterJet/FighterJet1.jpg"),
            file.path(imageLocation, "FighterJet/FighterJet2.jpg"),
            file.path(imageLocation, "FIghterJet/FighterJet3.jpg"),
            file.path(imageLocation, "FighterJet/FighterJet4.jpg"),
            file.path(imageLocation, "FighterJet/FighterJet5.jpg")
            )

# Setup a dataframe with the path to the images 
# MUST set the stringAsFactors to FALSE
imagesDF <- data.frame(Image = images, stringsAsFactors = FALSE)

# Let's add the image type
imagesDF$Type <- c("Fish","Fish","Fish","Fish","Fish",
                   "Helicopter","Helicopter","Helicopter","Helicopter","Helicopter",
                   "FighterJet","FighterJet","FighterJet","FighterJet","FighterJet")

# Now since we're going to train on these images, we need to have a label
# for each type that is a numeric value
imagesDF$Label[imagesDF$Type == "Fish"] <- 0
imagesDF$Label[imagesDF$Type == "Helicopter"] <- 1
imagesDF$Label[imagesDF$Type == "FighterJet"] <- 2

# Get the feature vectors of the images
# This requires a 4 step process:
# 1. Load the image(s) via the loadImage() transform
# 2. Resize the image(s) to the size required by the image model 
#    (224x224 for resnet models, 227x227 for the alexnet model)
# 3. Extract the pixels from the resized image(s) using the extractPixel() transform
# 4. Finally, featurize the image(s) via the featurizeImage() transform

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

# Now, given an image, the task is to find the best matching image 
# from the list of images we'd featurized above

imageFile <- c(file.path(imageLocation, "FighterJet/FighterJet6.jpg"))
# Convert to a dataframe so that we can give it the the image featurizer
imageToMatch <- data.frame(Image = imageFile, stringsAsFactors = FALSE)
# MicrosoftML expects a Label column to exist, but it can contain bogus data
imageToMatch[,"Label"] <- -99 

# Let's use the trained model to predict the type of image
prediction <- rxPredict(imageModel, data = imageToMatch, extraVarsToWrite = list("Label", "Image"))

# And the type of image is?
typeOfImage <- imagesDF$Type[which(imagesDF$Label == prediction$PredictedLabel)[[1]]]
cat(paste("The image is of type: ", typeOfImage))