library(RevoScaleR)
library(rpart)
library(mrsdeploy)

remoteLogin("http://127.0.0.1:12800", username="admin", password="Pa$$w0rd", session=FALSE)
name <- 'rtService'
ver <- '1.0'


form <- Kyphosis ~ Number + Start; parms <- list(prior = c(0.8, 0.2), loss = c(0, 2, 3, 0), split = 'gini');
method <- 'class'; parms <- list(prior = c(0.8, 0.2), loss = c(0, 2, 3, 0), split = 'gini');
control <- rpart.control(minsplit = 5, minbucket = 2, cp = 0.01, maxdepth = 10,
maxcompete = 4, maxsurrogate = 5, usesurrogate = 2, surrogatestyle = 0, xval = 0);
cost <- 1 + seq(length(attr(terms(form), 'term.labels')));
myModel <- rxDTree(formula = form, data = kyphosis, pweights = 'Age', method = method, parms = parms,
control = control, cost = cost, maxNumBins = 100, maxRowsInMemory = if(exists('.maxRowsInMemory')) .maxRowsInMemory else -1)
myData <- data.frame(Number=c(70), Start=c(3)); op1 <- rxPredict(myModel, data = myData);

op1 <- rxPredict(myModel, data = myData)

print(op1)

svc <- listServices()
if (length(svc) > 0)
{
  deleteService(name, ver)
}

svc <- publishService(name, v=ver, code=NULL, serviceType='Realtime', model=myModel)

op2 <- svc$consume(myData)
print(op2$outputParameters$outputData)