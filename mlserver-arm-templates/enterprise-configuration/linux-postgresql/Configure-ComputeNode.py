#!/usr/bin/python

import sys
import json
import os
from collections import OrderedDict

poolInitialSize = sys.argv[1]
poolMaxSize=sys.argv[2]

computeNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
f = open(computeNodeAppSettingsFilePath, "r")
jsondata = f.read().decode("utf-8-sig").encode("utf-8").replace("\r\n","")
data = json.loads(jsondata, object_pairs_hook=OrderedDict)

data["Pool"]["InitialSize"] = int(poolInitialSize)
data["Pool"]["MaxSize"] = int(poolMaxSize)

f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

os.system("/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentcomputenodeinstall")
