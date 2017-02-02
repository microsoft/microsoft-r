using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using FlightService.Models;

// ----------------------------------------------------------------------------
// Simple Test Driver to demonstrate calling the `FlightPredictionService` 
// using the AutoRest's generated client.
//
// First generate the AutoRest client libraries from the `swager.json`
// C:\>AutoRest.exe -CodeGenerator CSharp -Modeler Swagger -Input swagger.json -Namespace Flight
// ----------------------------------------------------------------------------
namespace FlightService
{
    class Program
    {
        static void Main(string[] args)
        {
            // Create a new `client` pointing to the R Server's endpoint
            var flightService = new FlightPredictionService(
                new Uri("YOUR SERVER"));

            // Add API key to the `client` given to us from Azure AD
            //AddApiKeyAuthorization(flightService);

            //You can use Login API Service
            UseLoginService(flightService);

            // Generate sample `input` parameters for the service: `data.frame`
            InputParameters inputs = PopulateInputs();

            Console.Out.WriteLine("********************Flight Prediction Demo*******************");
            // Invoke the `FlightPredicationService`
            var results = flightService.FlightPrediction(inputs);

            // View the results of the remote call
            Console.Out.WriteLine(results.OutputParameters.Answer);

            Console.WriteLine("********************Press any key to exit********************");
            Console.ReadKey();
        }

        /// <summary>
        /// Add the `Authorization Bearer` header value for the example given
        /// to us from Azure Active Directory. This value will be included in
        /// the HTTP header for verifying authenticity against the APIs.
        /// </summary>
        /// <param name="flightService"></param>
        private static void AddApiKeyAuthorization(FlightPredictionService flightService)
        {
            const string authority = "Authority server";
            const string clientId = "Client ID";
            const string clientKey = "Client Key";

            var authenticationContext = new AuthenticationContext(authority);
            var authenticationResult = authenticationContext.AcquireTokenAsync(
                clientId, new ClientCredential(clientId, clientKey));
            var accessToken = authenticationResult.Result.AccessToken;
            var headers = flightService.HttpClient.DefaultRequestHeaders;

            headers.Remove("Authorization");
            headers.Add("Authorization", $"Bearer {accessToken}");
        }

        /// <summary>
        /// Add the `Authorization Bearer` header value for the example given
        /// to us from Login API Call. This value will be included in
        /// the HTTP header for verifying authenticity against the APIs.
        /// </summary>
        /// <param name="flightService"></param>
        private static void UseLoginService(FlightPredictionService flightService)
        {
            const string user = "Enter your User ID";
            const string pwd = "Enter Your Password Here";
            var accessToken = flightService.Login(new LoginRequest(user, pwd));

            // Update the service to use the authToken
            string token = accessToken.AccessToken;
            UpdateAuthorizationHeader(flightService, token);
        }

        private static void UpdateAuthorizationHeader(FlightPredictionService client, string accessToken)
        {
            var headers = client.HttpClient.DefaultRequestHeaders;

            headers.Remove("Authorization");

            headers.Add(
                "Authorization",
                $"Bearer {accessToken}");
        }

        /// <summary>
        /// Build the example's `FlightPredictionService` input values as an
        /// R `data.frame`. 
        /// </summary>
        private static InputParameters PopulateInputs()
        {
            // > head(newflightData)
            var dataFrame = new Dictionary<string, object>
            {
                { "ArrDel15", new [] { 0, 0, 0, 0, 0, 1 } },
                { "Year", new [] { "2012", "2012", "2012", "2012", "2012", "2012" } },
                { "Month", new [] { "3", "6", "12", "5", "3", "8" } },
                { "DayofMonth", new [] { "18", "2", "17", "26", "5", "11" } },
                { "DayOfWeek", new [] { "7", "6", "1", "6", "1", "6" } },
                { "Carrier", new [] { "MQ", "WN", "AA", "MQ", "WN", "UA" } },
                { "OriginAirportID", new [] { "11298","13198", "11298", "11298", "10821", "13930" } },
                { "DestAirportID", new [] {  "10136", "10140", "10140", "10185", "10257", "10299" } },
                { "CRSDepTime", new [] { 9, 13, 10, 16, 9, 9 } },
                { "CRSArrTime", new [] { 1025, 1445, 1115, 1720, 1055, 1335 } },
                { "RelativeHumidityOrigin", new [] { 72.5, 36, 36, 51, 55, 47 } },
                { "AltimeterOrigin", new [] { 29.88, 29.82, 29.83, 29.93, 30.08, 29.96 } },
                { "DryBulbCelsiusOrigin", new [] { 23.15, 25.6, 16.1, 28.3, 5, 24.4 } },
                { "WindSpeedOrigin", new [] { 21.5, 7, 9, 15, 10, 9 } },
                { "VisibilityOrigin", new [] { 10, 10, 10, 10, 10, 10 } },
                { "DewPointCelsiusOrigin", new [] { 17.9, 9.4, 1.1, 17.2, -3.3, 12.2 } },
                { "RelativeHumidityDest", new [] { 62, 5, 47, 74, 49, 68 } },
                { "AltimeterDest", new [] { 29.8, 29.91, 29.99, 30.01, 30.09, 30.05 } },
                { "DryBulbCelsiusDest", new [] { 25, 29.4, 5.6, 23.3,-2.8, 18.3 } },
                { "WindSpeedDest", new [] { 21, 10, 0, 0, 11, 7 } },
                { "VisibilityDest", new [] { 10, 10, 10, 10, 10, 10 } },
                { "DewPointCelsiusDest", new [] { 17.2, -12.8, -5, 18.3, -12.2, 12.2 } }
            };

            return new InputParameters()
            {
                Newflightdata = dataFrame
            };
        }
    }
}