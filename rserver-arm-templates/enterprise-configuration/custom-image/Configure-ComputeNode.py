#!/usr/bin/python

import sys
import json
import os
from collections import OrderedDict

poolInitialSize = sys.argv[1]
poolMaxSize=sys.argv[2]

appSettingsFilePath = "/usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.ComputeNode/appsettings.json"
f = open(appSettingsFilePath, "r")
jsondata = f.read().decode("utf-8-sig").encode("utf-8").replace("\r\n","")
data = json.loads(jsondata, object_pairs_hook=OrderedDict)

data["Pool"]["InitialSize"] = int(poolInitialSize)
data["Pool"]["MaxSize"] = int(poolMaxSize)

f = open(appSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()
os.system("/usr/local/bin/dotnet /usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.Utils.AdminUtil/Microsoft.RServer.Utils.AdminUtil.dll -silentcomputenodeinstall")
os.system("iptables --flush")