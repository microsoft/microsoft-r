#!/usr/bin/python

import sys
import json
import os
import time
from collections import OrderedDict

password=sys.argv[1]
aadTenant=sys.argv[2]
aadClientId=sys.argv[3]
postgresqlConnectionString=sys.argv[4]

certLocation = "/home/webnode_usr/.dotnet/corefx/cryptography/x509stores/root"
certFileName = "25706AA4612FC42476B8E6C72A97F58D4BB5721B.pfx"
os.makedirs(certLocation)
os.system("cp " + certFileName + " " + certLocation)
os.system("chmod 777 " + certLocation + "/" + certFileName)

computeNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.3.0/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
webNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.3.0/o16n/Microsoft.MLServer.WebNode/appsettings.json"

data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["configured"] = "configured"
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

data = json.loads(open(webNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["ConnectionStrings"]["postgresql"]["Enabled"] = True
data["ConnectionStrings"]["postgresql"]["Connection"] = postgresqlConnectionString
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
data["BackEndConfiguration"]["Uris"]["Ranges"] =  ["http://10.0.1.0-255:12805"]
data["Authentication"]["JWTSigningCertificate"]["Enabled"] = True
data["Authentication"]["JWTSigningCertificate"]["StoreName"] = "Root"
data["Authentication"]["JWTSigningCertificate"]["StoreLocation"] = "CurrentUser"
data["Authentication"]["JWTSigningCertificate"]["SubjectName"] = "CN=LOCALHOST"

if aadTenant != "":
    data["Authentication"]["AzureActiveDirectory"]["Authority"] = "https://login.windows.net/" + aadTenant
    data["Authentication"]["AzureActiveDirectory"]["Audience"] = aadClientId
    data["Authentication"]["AzureActiveDirectory"]["Enabled"] = True

f = open(webNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

os.system("az ml admin node setup --webnode --admin-password \"" + password + "\" --confirm-password \"" + password + "\"")
os.system("service webnode stop")
time.sleep(120)
os.system("service webnode start")
os.system("iptables --flush")
