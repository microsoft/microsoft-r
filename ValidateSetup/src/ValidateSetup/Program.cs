using System;
using System.Collections.Generic;
using ValidateSetup.Models;

namespace Microsoft.ValidateSetup
{
    public class Program
    {
        public static void Main(string[] args)
        {
            AppConfiguration config = null;
            try
            {
                config = AppConfiguration.Instance;
            }
            catch(Exception e)
            {
                Console.WriteLine("Error is Loading Configuration File : " + e.Message);
            }

            if (config != null) {

                List<StatusResponse> webNodeStatus = new List<StatusResponse>();
                List<StatusResponse> lbStatus = new List<StatusResponse>();
                bool statusCheck = true;

                foreach (Uri uri in config.WebNodeUri)
                {
                    using (ValidateServer server = new ValidateServer(uri, config.User, config.Password)) { 
                        try
                        {
                            Console.WriteLine("************* Validating WebNode Server : " + uri.AbsoluteUri + " ***************");
                            server.ExecuteValidateServer();
                            webNodeStatus.Add(server.Status);
                        }
                        catch (Exception e)
                        {
                            string message = string.Format("Error Validating WebNode Server {0} ", uri.AbsoluteUri);
                            Console.WriteLine(message + e.Message);
                            statusCheck = false;
                        }
                    }
                }

                foreach (Uri uri in config.LoadBalancerUri)
                {
                    using (ValidateServer server = new ValidateServer(uri, config.User, config.Password))
                    {
                        try
                        {
                            Console.WriteLine("************* Validating LoadBalancer Server : " + uri.AbsoluteUri + " ***************");
                            server.ExecuteValidateServer();
                            lbStatus.Add(server.Status);
                        }
                        catch (Exception e)
                        {
                            string message = string.Format("Error Validating LoadBalancer Server {0} ", uri.AbsoluteUri);
                            Console.WriteLine(message + e.Message);
                            statusCheck = false;
                        }
                    }
                }

                if (statusCheck)
                {
                    ValidateExtensions.compareStatus(webNodeStatus);
                    ValidateExtensions.compareStatus(lbStatus);
                }
            }
        }
    }
}
