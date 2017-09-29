using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using ManualTransmissionClient.Api;
using ManualTransmissionClient.Client;
using ManualTransmissionClient.Model;

namespace ManualTransmissionFunctionApp
{
    public static class ManualTransmissionFunction
    {
        [FunctionName("ManualTransmissionFunction")]
        public static void Run([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer, TraceWriter log)
        {
            log.Info($"C# Timer trigger function executed at: {DateTime.Now}");

            // Initialize O16N params
            string webNodeUri = "http://test.southcentralus.cloudapp.azure.com:12800";
            string username = "admin";
            string password = "TestP@ssword90";

            // Login, Obtain access token and set header 
            UserApi userInstance = new UserApi(webNodeUri);
            var token = userInstance.Login(new LoginRequest(username, password));
            Configuration config = new Configuration(new ApiClient(webNodeUri), new System.Collections.Generic.Dictionary<string, string>() { { "Authorization", $"Bearer {token.AccessToken}" } });

            // Call ManualTransmissionService and log output to console window
            ManualTransmissionServiceApi instance = new ManualTransmissionServiceApi(config);
            InputParameters webServiceParameters = new InputParameters(120, 2.8m);
            WebServiceResult response = instance.ManualTransmission(webServiceParameters);
            log.Info($"Output : {response.OutputParameters.Answer}");
        }
    }
}
