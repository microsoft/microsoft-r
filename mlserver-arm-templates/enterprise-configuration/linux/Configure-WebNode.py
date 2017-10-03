#!/usr/bin/python

import sys
import json
import os
import platform
import subprocess
from collections import OrderedDict

password=sys.argv[1]
aadTenant=sys.argv[2]
aadClientId=sys.argv[3]
sqlServerConnectionString=sys.argv[4]

if platform.linux_distribution()[0] == "Ubuntu":
    os.system("apt-get update")
    os.system("apt-get -y install apt-transport-https")
    os.system("curl https://packages.microsoft.com/config/ubuntu/" + platform.linux_distribution()[1] + "/prod.list > ./microsoft-prod.list")
    os.system("cp ./microsoft-prod.list /etc/apt/sources.list.d/")
    os.system("curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg")
    os.system("cp ./microsoft.gpg /etc/apt/trusted.gpg.d/")
    os.system("apt-get update")
    os.system("apt-get -y install microsoft-mlserver-all-9.2.1")
    os.system("/opt/microsoft/mlserver/9.2.1/bin/R/activate.sh -l")    
else:
    os.system("yum-config-manager --add-repo http://packages.microsoft.com/config/rhel/7/prod.repo")
    os.system("yum -y install microsoft-mlserver-all-9.2.1")
    os.system("/opt/microsoft/mlserver/9.2.1/bin/R/activate.sh -l")
    os.system("iptables --flush")


os.environ["HOME"] = "/root"
os.system("mkdir /root/.cache")
os.system("mkdir /root/.dotnet")
os.system("mkdir /root/.nuget")
os.system("mkdir /root/.pki")
os.system("chmod 777 -R /root/.cache")
os.system("chmod 777 -R /root/.dotnet")
os.system("chmod 777 -R /root/.nuget")
os.system("chmod 777 -R /root/.pki")
p = subprocess.Popen(["/usr/local/bin/dotnet", "restore"], cwd=".")
p.wait()
p = subprocess.Popen(["/usr/local/bin/dotnet", "run"], cwd=".")
p.wait()

computeNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
webNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.WebNode/appsettings.json"

data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["configured"] = "configured"
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

data = json.loads(open(webNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["ConnectionStrings"]["sqlserver"]["Enabled"] = True
data["ConnectionStrings"]["sqlserver"]["Connection"] = sqlServerConnectionString
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
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

os.system("/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentwebnodeinstall \"" + password + "\"")

data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data.pop('configured', None)
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()