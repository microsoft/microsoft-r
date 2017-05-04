using Microsoft.Rest.Serialization;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ValidateSetup.Models;

namespace Microsoft.ValidateSetup
{
    public static partial class ValidateExtensions
    {
        public static void PrintStatus(this ValidateServer server)
        {
            printStatusResponse(server.Status);

        }

        private static void printStatusResponse(StatusResponse response)
        {
            Console.WriteLine("Status Code: " + response.StatusCode);
            printComponents(response.Components);
            printDetails(response.Details);
        }

        private static void printDetails(IDictionary<string, object> details)
        {
            if(details != null)
            {
                if (details.Count > 0)
                {
                    Console.WriteLine("Details");
                    foreach (KeyValuePair<string, object> kv in details)
                    {
                        if (kv.Value != null)
                        {
                            Console.WriteLine(kv.Key + " : " + kv.Value);
                        }
                    }

                    Console.WriteLine();
                }
            }
        }

        private static void printComponents(IDictionary<string, StatusResponse> components)
        {
            if (components != null)
            {
                if (components.Count > 0)
                {
                    Console.WriteLine("components");
                    foreach (KeyValuePair<string, StatusResponse> kv in components)
                    {
                        if (kv.Value != null)
                        {
                            Console.WriteLine(kv.Key);
                            printStatusResponse(kv.Value);
                        }
                    }

                    Console.WriteLine();
                }
            }
        }


        public static void compareStatus(List<StatusResponse> status)
        {
            if (status != null && status.Count > 0)
            {
                bool compareFailed = false;
                StatusResponse original = status[0];
                foreach(StatusResponse response in status)
                {
                    if(!compareStatus(original, response))
                    {
                        compareFailed = true;
                    }
                }

                if (compareFailed)
                {
                    Console.WriteLine("Staus Check Failed, Please Look into status details and correct the error");
                }else
                {
                    Console.WriteLine("Staus Check Passed");
                }
            }
        }

        private static bool compareStatus(StatusResponse response1, StatusResponse response2)
        {
            string strResponse1 = SafeJsonConvert.SerializeObject(response1);
            string strResponse2 = SafeJsonConvert.SerializeObject(response2);

            JObject jsonResponse1 = JObject.Parse(strResponse1);
            JObject jsonResponse2 = JObject.Parse(strResponse2);

            return JToken.DeepEquals(jsonResponse1, jsonResponse2);
        }
    }
}
