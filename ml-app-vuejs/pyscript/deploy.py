'''
prerequisites:
1. install mls
2. install tensorflow on the remote server (can be done in client side using dedicated pool and init function)
3. create a tensorflow image classification model, "tensorflow_script.py" in this example
'''

from azureml.deploy import DeployClient
from azureml.deploy.server import MLServer
from azureml.common.configuration import Configuration
import numpy as np

#log into the remote server
HOST = 'http://*****:12800'
context = ('admin', '*****')
client = DeployClient(HOST, use=MLServer, auth=context)

# read the tensorflow model in a file:
with open('C:/Users/xikou/Desktop/tensorflow_script.py', 'r') as myfile:
     script = myfile.read()
# Deploy the web service 
service_name = 'ImageClassification'
service_version = '1.0.0'
service_test = client.service(service_name)\
        .version(service_version)\
        .code_str(script)\
        .inputs(image=str)\
        .outputs(answer=np.array)\
        .description('service for image classification')\
        .deploy()
		
#consume the service		
import base64
with open(image, "rb") as imageFile:
    image_data = imageFile.read()
    base64_string = str(base64.b64encode(image_data).decode("utf-8"))
    res = service_test.consume(base64_string)
print(res)