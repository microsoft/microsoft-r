using System;
using Microsoft.Extensions.Configuration;
using System.Linq;
using System.Collections.Generic;
using System.IO;

namespace Microsoft.ValidateSetup
{
    public sealed class AppConfiguration
    {
        private static volatile AppConfiguration instance;
        private static object syncRoot = new Object();

        private AppConfiguration() { }

        public static AppConfiguration Instance
        {
            get
            {
                if (instance == null)
                {
                    lock (syncRoot)
                    {
                        if (instance == null)
                        {
                            instance = new AppConfiguration();
                            instance.LoadConfiguration();
                        }
                    }
                }

                return instance;
            }
        }

        private void LoadConfiguration()
        {

            string path = Directory.GetCurrentDirectory();
            string configFileName = "appsettings.json";
            string fullFilePath = Path.Combine(path, configFileName);
            if (!File.Exists(fullFilePath))
            {
                // Because of File.Delete doesn't throw any exception in case file not found
                throw new FileNotFoundException("appsettings.json File Not Found");
            }

            var builder = new ConfigurationBuilder()
                .AddJsonFile(fullFilePath, optional: true, reloadOnChange: true);
            
            Configuration = builder.Build();

            var serverSection = Configuration.GetSection("Servers");
            WebNodeUri = getServerUri(serverSection?.GetSection("WebNode"));
            LoadBalancerUri = getServerUri(serverSection?.GetSection("LoadBalancer"));

            var authSection = Configuration.GetSection("Authentication");
            User = getUser(authSection);
            Password = getPassword(authSection);
            GenerateSwagger = getGenereateSwagger(Configuration);
        }

        public IConfigurationRoot Configuration { get; private set; }

        public List<Uri>  WebNodeUri { get; private set; }

        public List<Uri> LoadBalancerUri { get; private set; }

        public string User { get; private set; }

        public string Password { get; private set; }

        public bool GenerateSwagger { get; private set; }

        private List<Uri> getServerUri(IConfiguration configuration)
        {
            var valuesSection = configuration?.GetSection("Values");

            return valuesSection
                ?.GetChildren()
                .Select(section => new Uri(section.Value)).ToList();
        }

        private string getUser(IConfiguration configuration)
        {
            string user = configuration?.GetSection("User").Value;

            if (string.IsNullOrEmpty(user))
            {
                throw new Exception("User not provided");
            }

            return user;
        }

        private string getPassword(IConfiguration configuration)
        {
            string password = configuration?.GetSection("Password").Value;

            if (string.IsNullOrEmpty(password))
            {
                throw new Exception("Password not provided");
            }

            return password;
        }

        private bool getGenereateSwagger(IConfiguration configuration)
        {
            bool result = false;

            try
            {
                result = Boolean.Parse(configuration?.GetSection("GenerateSwagger").Value);
            }
            catch
            { 
                // do nothing
            }

            return result;
        }

    }
}