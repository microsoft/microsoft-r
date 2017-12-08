# -- Import the DeployClient and MLServer classes from the azureml-model-management-sdk package.
from azureml.deploy import DeployClient
from azureml.deploy.server import MLServer
from azureml.common.configuration import Configuration

# -- Define the location of the ML Server --
# -- for local onebox for Machine Learning Server: http://localhost:12800
# -- Replace with connection details to your instance of ML Server. 
HOST = 'http://localhost:12800'
context = ('<username>', '<password>')
client = DeployClient(HOST, use=MLServer, auth=context)

# Define function to obtain Weather Report"
def getWeatherReport(latitude, longitude):
    import requests
    # Obtain APPID from openweathermap.org
    appid = "<Developer App Id>"
    resp = requests.get("http://api.openweathermap.org/data/2.5/forecast?APPID={}&cnt=16&lat={}&lon={}".format(appid, latitude, longitude))
    return resp.text

# Delete Service if it already exists 
service_name = 'WeatherService'
service_version = '1.0.0'
client.delete_service(service_name, version=service_version)

# Deploy the web service 
service = client.service(service_name)\
        .version(service_version)\
        .code_fn(getWeatherReport)\
        .inputs(latitude=float, longitude=float)\
        .outputs(report=str)\
        .description('Weather Service Report')\
        .deploy()

# Invoke the service with sample latitude longitude values
latitude = 47.6477248
longitude = -122.137314
res = service.getWeatherReport(latitude, longitude)

# -- Pluck out the named output `report` as defined during publishing and print --
print(res.output('report'))

# Save service swagger to json file 
print(service.swagger())
with open("weather-service-swagger.json", "w") as swagger_file:
    swagger_file.write("%s" % service.swagger())

# Generate client in C# using the above generated swagger file
import urllib, requests, json, ssl, os
f = open("weather-service-swagger.json", "r")
swagger = f.read()
payload = { 'options' : { 'packageName' : service_name }, 'spec' : json.loads(swagger) }

# Change csharp to java if you wish generate java client. List of supported clients : http://generator.swagger.io/api/gen/clients
r = requests.post("http://generator.swagger.io/api/gen/clients/csharp",\
                    headers = { "content-type" : "application/json"},\
                    data = json.dumps(payload))
ssl._create_default_https_context = ssl._create_unverified_context
urllib.request.urlretrieve(json.loads(r.text)['link'], "{}.zip".format(service_name))
print("Client code location : {}".format(os.path.join(os.getcwd() , "{}.zip".format(service_name))))
f.close()
