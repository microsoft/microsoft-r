using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using ValidateSetup;
using ValidateSetup.Models;
using System.Net.Http.Headers;

namespace Microsoft.ValidateSetup
{
    public class ValidateServer : IDisposable
    {
        private string password;
        private MRSServer mrsServer;
        private string accessToken;
        string serviceName;
        string realTimeServiceName;
        string version = "v1.0.0";
        string snapshotId;
        string sessionId;
        string swaggerFileExtension = ".json";
        bool snapShotCreated = false;
        bool sessionCreated = false;
        bool serviceCreated = false;
        bool realTimeServiceCreated = false;
        bool disposed = false;

        public ValidateServer(Uri uri, string user, string password)
        {
            if (uri == null)
            {
                throw new ArgumentNullException(nameof(uri));
            }

            if (user == null)
            {
                throw new ArgumentNullException(nameof(user));
            }

            if (password == null)
            {
                throw new ArgumentNullException(nameof(password));
            }

            Uri = uri;
            User = user;
            this.password = password;

            mrsServer = new MRSServer(uri);
        }

        public Uri Uri { get; private set; }

        public string User { get; private set; }

        private void Login()
        {
            try
            {
                LoginRequest request = new LoginRequest(User, password);
                var response = mrsServer.Login(request);
                // Update the service to use the authToken
                accessToken = response.AccessToken;
                SetAuthorizationHeader(mrsServer.HttpClient.DefaultRequestHeaders);
            }
            catch (Exception e)
            {
                throw new Exception("Login Failed : " + e.Message);
            }

        }

        private void SetAuthorizationHeader(HttpRequestHeaders defaultRequestHeaders)
        {
            defaultRequestHeaders.Remove("Authorization");

            defaultRequestHeaders.Add(
                "Authorization",
                $"Bearer {accessToken}");
        }

        private void Logout()
        {
            // We dont have Logout REST API Yet....

        }

        private void getStatus()
        {
            Status = mrsServer.Status();
        }

        public StatusResponse Status { get; private set; }

        public bool ValidatedServer { get; private set; }

        public void ExecuteValidateServer()
        {
            Login();
            getStatus();
            this.PrintStatus();
            if (Status.StatusCode.Equals("pass", StringComparison.OrdinalIgnoreCase))
            {
                createSession();
                executeCode("carsModel <- glm(formula = am ~ hp + wt, data = mtcars, family = binomial)");
                createSnapShot();
                publishService();
                getSwaggerJson(serviceName);
                consumeService();
                publishRealTimeService();
                getSwaggerJson(realTimeServiceName);
                consumeRealTimeService();
                deleteSnapShot();
                deleteService(serviceName);
                deleteRealTimeService(realTimeServiceName);
                closeSession();
                ValidatedServer = true;
            }
            else
            {
                string message = string.Format("Status of Server {0} is {1}", Uri.AbsoluteUri, Status.StatusCode);
                Console.WriteLine("message");
            }
        }

        private void publishService()
        {
            try
            {
                PublishWebServiceRequest request = new PublishWebServiceRequest();
                serviceName = "myMtService" + DateTime.Now.Ticks;
                request.InputParameterDefinitions = new List<ParameterDefinition>
                {
                    new ParameterDefinition("hp", "numeric"),
                    new ParameterDefinition("wt", "numeric")
                };
                request.OutputParameterDefinitions = new List<ParameterDefinition>
                {
                    new ParameterDefinition("answer", "numeric")
                };

                string code = "answer <- (function (hp, wt) \n{\n    newdata <- data.frame(hp = hp, wt = wt)\n    predict(carsModel, newdata, type = \"response\")\n})(hp, wt)";

                request.Code = code;
                request.SnapshotId = snapshotId;
                request.OperationId = "manualTransmission";
                request.RuntimeType = RuntimeType.R;

                string message = string.Format("Publishing service {0}, version {1}", serviceName, version);
                Console.WriteLine(message);
                var response = mrsServer.PublishWebServiceVersion(serviceName, version, request);
                serviceCreated = true;
            }
            catch (Exception e)
            {
                string message = string.Format("Publish service {0}, version {1} failed ", serviceName, version);
                throw new Exception(message + e.Message);
            }
        }

        private void deleteServiceInternal(string service)
        {

            try
            {
                mrsServer.DeleteWebServiceVersion(service, version);
            }
            catch (Exception e)
            {
                string message = string.Format("Delete service {0}, version {1} failed ", service, version);
                throw new Exception(message + e.Message);
            }

        }

        private void deleteService(string service)
        {
            if (serviceCreated)
            {
                try
                {
                    deleteServiceInternal(service);
                    serviceCreated = false;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }

        private void deleteRealTimeService(string service)
        {
            if (realTimeServiceCreated)
            {
                try
                {
                    deleteServiceInternal(service);
                    realTimeServiceCreated = false;
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }

        private void createSession()
        {
            try
            {
                CreateSessionRequest request = new CreateSessionRequest();
                var response = mrsServer.CreateSession(request);
                this.sessionId = response.SessionId;
                Console.WriteLine("Create Session :" + sessionId);
                sessionCreated = true;
            }
            catch (Exception e)
            {
                throw new Exception("Create Session Failed : " + e.Message);
            }
        }

        private void closeSession()
        {
            if (sessionCreated)
            {
                try
                {
                    var response = mrsServer.CloseSession(sessionId);
                    sessionCreated = false;
                }
                catch (Exception e)
                {
                    string message = string.Format("Close session {0} failed ", sessionId);
                    throw new Exception(message + e.Message);
                }
            }
        }

        private void executeCode(string code)
        {
            try
            {
                ExecuteRequest request = new ExecuteRequest();
                request.Code = code;
                var response = mrsServer.ExecuteCode(sessionId, request);

                if (response.Success == false)
                {
                    throw new Exception(response.ErrorMessage);
                }

            }
            catch (Exception e)
            {
                throw new Exception("Execute Code Failed : " + e.Message);
            }
        }

        private void createSnapShot()
        {
            try
            {
                CreateSnapshotRequest request = new CreateSnapshotRequest();
                request.Name = "MyNewSnapShot" + DateTime.Now.Ticks;
                var response = mrsServer.CreateSnapshot(sessionId, request);
                snapshotId = response.SnapshotId;
                Console.WriteLine("Create SnapShot :" + snapshotId);
                snapShotCreated = true;
            }
            catch (Exception e)
            {
                throw new Exception("Create Snapshot Failed " + e.Message);
            }
        }

        private void deleteSnapShot()
        {
            if (snapShotCreated)
            {
                try
                {
                    mrsServer.DeleteSnapshot(snapshotId);
                    snapShotCreated = false;
                }
                catch (Exception e)
                {
                    throw new Exception("Delete SnapShot :" + snapshotId + " " + e.Message);
                }
            }
        }

        private void getSwaggerJson(string service)
        {
            try
            {
                var response = mrsServer.GetWebServiceSwagger(service, version);
                var result = JsonConvert.SerializeObject(response, Formatting.Indented);

                if (AppConfiguration.Instance.GenerateSwagger)
                {
                    string path = Directory.GetCurrentDirectory();
                    string fullFilePath = Path.Combine(path, (service + DateTime.Now.Ticks + swaggerFileExtension));

                    FileStream fs = new FileStream(fullFilePath, FileMode.CreateNew);
                    using (StreamWriter sw = new StreamWriter(fs))
                    {
                        sw.WriteLine(result);
                    }
                }
            }
            catch (Exception e)
            {
                string message = string.Format("Get Swagger {0}, version {1} failed ", service, version);
                throw new Exception(message + e.Message);
            }
        }

        private void consumeService()
        {
            try
            {
                string message = string.Format("Consume Service {0}, version {1} ", serviceName, version);
                ConsumeService service = new ConsumeService(Uri);
                SetAuthorizationHeader(service.HttpClient.DefaultRequestHeaders);
                InputParameters inputParams = new InputParameters(120, 2.8);

                Console.WriteLine(message);
                var response = service.ManualTransmission(serviceName, version, inputParams);

                if (response.Success == false)
                {
                    throw new Exception(response.ErrorMessage);
                }

                Console.WriteLine("Consume Service Result : " + response.OutputParameters.Answer);
            }
            catch (Exception e)
            {
                string message = string.Format("Consume Service {0}, version {1} failed ", serviceName, version);
                throw new Exception(message + e.Message);
            }
        }

        private void publishRealTimeService()
        {
            try
            {
                string message = string.Format("Publishing Real Time service {0}, version {1}", realTimeServiceName, version);
                Console.WriteLine(message);
                executeCode("kyphosisModel <- rxLogit(Kyphosis ~ Age, data = kyphosis)");
                executeCode("realTimeModel <- rxSerializeModel(kyphosisModel)");
                executeCode("writeBin(realTimeModel, 'kyphosisService.bin')");

                realTimeServiceName = "kyphosisService" + DateTime.Now.Ticks;
                Stream model = mrsServer.GetSessionFile(sessionId, "kyphosisService.bin");

                string realTimeServiceFile = realTimeServiceName + ".bin";
                using (var stream = new FileStream(realTimeServiceFile, FileMode.Create, FileAccess.Write))
                {
                    model.CopyTo(stream);
                }

                Func<Stream> modelStream = () => File.OpenRead(realTimeServiceFile);

                var response = mrsServer.PublishRealtimeWebServiceByNameVersion(realTimeServiceName, version, modelStream(), null, realTimeServiceName);

                try
                {
                    // Delete file after publishing, as we no longer use it.
                    File.Delete(realTimeServiceFile);
                }
                catch
                {
                    // do nothing
                }

                realTimeServiceCreated = true;

            }
            catch (Exception e)
            {
                string message = string.Format("Publish Real Time service {0}, version {1} failed ", realTimeServiceName, version);
                throw new Exception(message + e.Message);
            }
        }

        private void consumeRealTimeService()
        {
            try
            {
                string message = string.Format("Consume Real Time Service {0}, version {1} ", realTimeServiceName, version);
                ConsumeService service = new ConsumeService(Uri);
                SetAuthorizationHeader(service.HttpClient.DefaultRequestHeaders);
                var dataFrame = new Dictionary<string, object>
                {
                    { "Kyphosis", new [] { "absent", "absent" } },
                    { "Age", new [] { 71, 55 } },
                    { "Number", new [] {3 , 4} },
                    { "Start", new [] { 5 , 7} }
                };

                ValidateRealTimeService.Models.InputParameters inputParams = new ValidateRealTimeService.Models.InputParameters()
                {
                    InputData = dataFrame
                };

                Console.WriteLine(message);
                var response = service.KyphosisService(realTimeServiceName, version, inputParams);

                if (response.Success == false)
                {
                    throw new Exception(response.ErrorMessage);
                }

                Console.WriteLine("Consume Real Time Service Result : " + response.OutputParameters.OutputData);
            }
            catch (Exception e)
            {
                string message = string.Format("Consume Real Time Service {0}, version {1} failed ", realTimeServiceName, version);
                throw new Exception(message + e.Message);
            }
        }

        public void Dispose()
        {
            if (!disposed)
            {
                try
                {
                    deleteSnapShot();
                    deleteService(serviceName);
                    deleteRealTimeService(realTimeServiceName);
                    closeSession();
                }
                catch
                {
                    // Do nothing
                }

                disposed = true;
            }
        }
    }
}
