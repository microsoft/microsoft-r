#!/usr/bin/python

import sys
import json
import os
from collections import OrderedDict

linuxOS=sys.argv[1]
password=sys.argv[2]
aadTenant=sys.argv[3]
aadClientId=sys.argv[4]
sqlServerConnectionString=sys.argv[5]

appSettingsFilePath = "/usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.WebNode/appsettings.json"
f = open(appSettingsFilePath, "r")
jsondata = f.read().decode("utf-8-sig").encode("utf-8").replace("\r\n","")
data = json.loads(jsondata, object_pairs_hook=OrderedDict)

data["ConnectionStrings"]["sqlserver"]["Enabled"] = True
data["ConnectionStrings"]["sqlserver"]["Connection"] = sqlServerConnectionString
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
data["BackEndConfiguration"]["Uris"]["Ranges"] =  ["http://10.0.1.0-255:12805"]
data["Authentication"]["JWTKey"] = "eyJEIjoiVjVwWktpNXY0SGtxN3FDRzdSNC9aMHpMWnAzVWxSZjd0aE0vMzhxb0"

if aadTenant != "":
    data["Authentication"]["AzureActiveDirectory"]["Authority"] = "https://login.windows.net/" + aadTenant
    data["Authentication"]["AzureActiveDirectory"]["Audience"] = aadClientId
    data["Authentication"]["AzureActiveDirectory"]["Enabled"] = True

f = open(appSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()

os.system("/usr/local/bin/dotnet /usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.Utils.AdminUtil/Microsoft.RServer.Utils.AdminUtil.dll -silentwebnodeinstall \"" + password + "\"")