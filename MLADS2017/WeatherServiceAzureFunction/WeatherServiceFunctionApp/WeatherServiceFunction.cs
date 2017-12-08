using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using WeatherService.Api;
using WeatherService.Client;
using WeatherService.Model;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;
using Newtonsoft.Json.Linq;

namespace WeatherServiceFunctionApp
{
    public static class WeatherServiceFunction
    {
        [FunctionName("WeatherServiceFunction")]
        // To trigger at 8 AM everyday use this : "0 0 8 * * 1-5"
        // To trigger at 9:30 AM everyday use this : "0 30 9 * * 1-5"
        // Currently set to run every 5 minutes : 
        public static void Run([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer, TraceWriter log)
        {
            log.Info($"C# Timer trigger function executed at: {DateTime.Now}");

            // Initialize O16N params
            string webNodeUri = "http://<server-ip-address>:12800";
            string username = "<username>";
            string password = "<password>";

            // Login, Obtain access token and set header 
            UserApi userInstance = new UserApi(webNodeUri);
            var token = userInstance.Login(new LoginRequest(username, password));
            Configuration config = new Configuration(new ApiClient(webNodeUri), new System.Collections.Generic.Dictionary<string, string>() { { "Authorization", $"Bearer {token.AccessToken}" } });

            // Call ManualTransmissionService and log output to console window
            WeatherServiceApi instance = new WeatherServiceApi(config);
            InputParameters webServiceParameters = new InputParameters(47.648445m, -122.145028m);
            WebServiceResult response = instance.GetWeatherReport(webServiceParameters);

            // Parsing the Weather Report Json for current Temperature in Celsius
            var reportJson = response.OutputParameters.Report;
            var obj = JObject.Parse(reportJson);
            var temperatureInKelvin = obj["list"][0]["main"]["temp"];
            var temperatureInCelsius = Convert.ToInt32(temperatureInKelvin) - 273;

            // SMS the temperature 
            TwilioClient.Init("<username>", "<password>");
            var message = MessageResource.Create(
                new PhoneNumber("<phone number>"),
                from: new PhoneNumber("<phone number>"),
                body: $"Temperature : {temperatureInCelsius}�C"
            );
        }
    }
}
