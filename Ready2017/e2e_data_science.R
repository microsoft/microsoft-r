library(sparklyr)
library(dplyr)


rxRoc <- function(...){
  previousContext <- rxSetComputeContext(RxLocalSeq())
  
  # rxRoc requires local compute context
  roc <- RevoScaleR::rxRoc(...)
  
  rxSetComputeContext(previousContext)
  
  return(roc)
}

cc <- rxSparkConnect(interop = "sparklyr",
                     reset = T,
                     consoleOutput = TRUE
                     # numExecutors = 4,
                     # executorCores = 8,
                     # executorMem = "4g"
)

sc <- rxGetSparklyrConnection(cc)

airlineDF <- spark_read_csv(sc = sc, 
                            name = "airline",
                            path = "hdfs://mycluster/share/Air2009to2012CSV", 
                            header = TRUE, 
                            infer_schema = FALSE, # Avoids parsing error
                            null_value = "null")

weatherDF <- spark_read_csv(sc = sc, 
                            name = "weather",
                            path = "hdfs://mycluster/share/Weather",
                            header = TRUE,
                            infer_schema = TRUE,
                            null_value = "null")

################################################
# Transform the data
################################################


airlineDF <- airlineDF %>% rename(
  ArrDel15 = ARR_DEL15,
  Year = YEAR,
  Month = MONTH,
  DayOfMonth = DAY_OF_MONTH,
  DayOfWeek = DAY_OF_WEEK,
  Carrier = UNIQUE_CARRIER,
  OriginAirportID = ORIGIN_AIRPORT_ID,
  DestAirportID = DEST_AIRPORT_ID,
  CRSDepTime = CRS_DEP_TIME,
  CRSArrTime = CRS_ARR_TIME
)


# Keep only the desired columns from the flight data 

airlineDF <- airlineDF %>% select(ArrDel15, Year, Month, DayOfMonth, 
                                  DayOfWeek, Carrier, OriginAirportID, 
                                  DestAirportID, CRSDepTime, CRSArrTime)

# Round down scheduled departure time to full hour

airlineDF <- airlineDF %>% mutate(CRSDepTime = floor(CRSDepTime / 100))

weatherDF <- weatherDF %>% rename(
  OriginAirportID = AirportID,
  Year = AdjustedYear,
  Month = AdjustedMonth,
  DayOfMonth = AdjustedDay,
  CRSDepTime = AdjustedHour)

weatherSummary <- weatherDF %>% 
  group_by(Year, Month, DayOfMonth, CRSDepTime, OriginAirportID) %>% 
  summarise(Visibility = mean(Visibility),
            DryBulbCelsius = mean(DryBulbCelsius),
            DewPointCelsius = mean(DewPointCelsius),
            RelativeHumidity = mean(RelativeHumidity),
            WindSpeed = mean(WindSpeed),
            Altimeter = mean(Altimeter))

#######################################################
# Join airline data with weather at Origin Airport
#######################################################

originDF <- left_join(x = airlineDF,
                      y = weatherSummary)

originDF <- originDF %>% rename(VisibilityOrigin = Visibility,
                                DryBulbCelsiusOrigin = DryBulbCelsius,
                                DewPointCelsiusOrigin = DewPointCelsius,
                                RelativeHumidityOrigin = RelativeHumidity,
                                WindSpeedOrigin = WindSpeed,
                                AltimeterOrigin = Altimeter)

#######################################################
# Join airline data with weather at Destination Airport
#######################################################

weatherSummary <- weatherSummary %>% rename(DestAirportID = OriginAirportID)

destDF <- left_join(x = originDF,
                    y = weatherSummary)

airWeatherDF <- destDF %>% rename(
  VisibilityDest = Visibility,
  DryBulbCelsiusDest = DryBulbCelsius,
  DewPointCelsiusDest = DewPointCelsius,
  RelativeHumidityDest = RelativeHumidity,
  WindSpeedDest = WindSpeed,
  AltimeterDest = Altimeter)

#######################################################
# Register the joined data as a Spark SQL/Hive table
#######################################################

airWeatherDF <- airWeatherDF %>% sdf_register("flightsweather")
tbl_cache(sc, "flightsweather")

# To see that the table was created list all Hive tables
src_tbls(sc)

# split out the training data

airWeatherTrainDF <- airWeatherDF %>% filter(Year < 2012) 
airWeatherTrainDF <- airWeatherTrainDF %>% sdf_register("flightsweathertrain")

# split out the testing data

airWeatherTestDF <- airWeatherDF %>% filter(Year == 2012 & Month == 1)
airWeatherTestDF <- airWeatherTestDF %>% sdf_register("flightsweathertest")

# Create ScaleR data source objects

colInfo <- list(
  ArrDel15 = list(type="numeric"),
  CRSArrTime = list(type="integer"),
  Year = list(type="factor"),
  Month = list(type="factor"),
  DayOfMonth = list(type="factor"),
  DayOfWeek = list(type="factor"),
  Carrier = list(type="factor"),
  OriginAirportID = list(type="factor"),
  DestAirportID = list(type="factor")
)

finalData <- RxHiveData(table = "flightsweather", colInfo = colInfo)
colInfoFull <- rxCreateColInfo(finalData)

trainDS <- RxHiveData(table = "flightsweathertrain", colInfo = colInfoFull)
testDS <- RxHiveData(table = "flightsweathertest", colInfo = colInfoFull)

################################################
# Train and Test a Logistic Regression model
################################################

formula <- as.formula(ArrDel15 ~ Month + DayOfMonth + DayOfWeek + Carrier + OriginAirportID + 
                        DestAirportID + CRSDepTime + CRSArrTime + RelativeHumidityOrigin + 
                        AltimeterOrigin + DryBulbCelsiusOrigin + WindSpeedOrigin + 
                        VisibilityOrigin + DewPointCelsiusOrigin + RelativeHumidityDest + 
                        AltimeterDest + DryBulbCelsiusDest + WindSpeedDest + VisibilityDest + 
                        DewPointCelsiusDest
)

# Use the scalable rxLogit() function

logitModel <- rxLogit(formula, data = trainDS)

summary(logitModel)

save(logitModel, file = "logitModelSubset.RData")

# Predict over test data (Logistic Regression).

rxOptions(fileSystem = RxHdfsFileSystem())

dataDir = "/user/sshuser/ready"
logitPredict <- RxXdfData(file.path(dataDir, "logitPredictSubset"))

# Use the scalable rxPredict() function

rxPredict(logitModel, data = testDS, outData = logitPredict,
          extraVarsToWrite = c("ArrDel15"),
          type = 'response', overwrite = TRUE)

# Calculate ROC and Area Under the Curve (AUC).

logitRoc <- rxRoc("ArrDel15", "ArrDel15_Pred", logitPredict)
logitAuc <- rxAuc(logitRoc)
# 0.645261

plot(logitRoc)

##########################################################################
# Partition by OriginAirportID and run many models (pleasingly parallel)
##########################################################################

averageDelay <- function(keys, data, formula) {
  logitModel <- rxLogit(formula, data = trainDS)
}

models <- rxExecBy(trainDS, keys = c("OriginAirportID"), func = averageDelay, funcParams = list(formula = formula))

# H2O training

install.packages("rsparkling")
options(rsparkling.sparklingwater.version = "2.0.3")

h2oTraining <- as_h2o_frame(sc, airWeatherTrainDF, strict_version_check = FALSE)
h2oTest <- as_h2o_frame(sc, airWeatherTestDF, strict_version_check = FALSE)

# Train a linear model with H2O

glm_model <- h2o.glm(x = c("ArrDel15"), 
                     y = c("OriginAirportID"),
                     family = "binomial",
                     link = "logit",
                     training_frame = h2oTraining,
                     lambda_search = TRUE)

rxSparkDisconnect(cc)
