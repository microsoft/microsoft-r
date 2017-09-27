#!/usr/bin/python

import sys
import json
import os
import platform
from collections import OrderedDict

poolInitialSize = sys.argv[1]
poolMaxSize=sys.argv[2]

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

appSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
f = open(appSettingsFilePath, "r")
jsondata = f.read().decode("utf-8-sig").encode("utf-8").replace("\r\n","")
data = json.loads(jsondata, object_pairs_hook=OrderedDict)

data["Pool"]["InitialSize"] = int(poolInitialSize)
data["Pool"]["MaxSize"] = int(poolMaxSize)

f = open(appSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()
os.system("/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentcomputenodeinstall")
os.system("iptables --flush")