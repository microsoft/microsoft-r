# Instructions

1. [Set up a Machine Learning server instance using ARM Templates](https://blogs.msdn.microsoft.com/mlserver/2017/11/21/configuring-microsoft-machine-learning-server-to-operationalize-analytics-using-arm-templates/).

2. Publish Weather Service using python code from [here](https://github.com/Microsoft/microsoft-r/tree/master/MLADS2017/WeatherService). You can obtain openweathermap API Key from [here](http://openweathermap.org/appid)

3. Open WeatherServiceAzureFunction.sln in [Visual Studio 2017](https://www.visualstudio.com/downloads/) and fill the required values in WeatherServiceFunction.cs and local.settings.json file. You can sign up for Twilio Trial [here](https://www.twilio.com/try-twilio). You can also [publish the Azure Function directly from Visual Studio](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs).


## Azure Functions Integration with Microsoft Machine Learning Server
![Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/MLADS2017/WeatherServiceAzureFunction/mls-azure-function.png)

## Architecture of WeatherService SMS application using Twilio
![Architecture](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/MLADS2017/WeatherServiceAzureFunction/mls-weather-service.png)

## Sample SMS Notification
![Notification](https://raw.githubusercontent.com/Microsoft/microsoft-r/master/MLADS2017/WeatherServiceAzureFunction/temperature-notification.jpg)
