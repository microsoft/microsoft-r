#!/usr/bin/python

import sys
import json
import os
import subprocess
import time
import platform
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

computeNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["configured"] = "configured"
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()

appSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.WebNode/appsettings.json"
data = json.loads(open(appSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)

data["ConnectionStrings"]["sqlserver"]["Enabled"] = True
data["ConnectionStrings"]["sqlserver"]["Connection"] = sqlServerConnectionString
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
data["ConnectionStrings"]["defaultDb"]["Enabled"] = False
data["BackEndConfiguration"]["Uris"]["Ranges"] =  ["http://10.0.1.0-255:12805"]
data["Authentication"]["JWTKey"] = "eyJEIjoiRWEyWS81ck9rY3hJd05PQ3F1VE8xSm1pK2dPTm03d0xIcEJzUXFYVDl4RkhveUpqWHVNOGdWVFdOZVFwWlZYamZWbEs4aHBFaWd4elhteWNoZ0Y3TEZUM0pzNm5FSHZZc2hEMzI2MDdQMm9Dc0dpYjJ4THR2eWxSUjRxTDdmTElZMUI0RnY2c09ienhoWE1ya2xIaDdHMUZMU0xyc3ZPM0xGcklFZmV4eTBkZkJCa0VEK1hOTmtDM1IxQzNSdDRGMWtsYXBnU2d6Q2x4TDJmc3lCdk5GWmd5M1B6U2FnMDBNWkRQVlVHTVRaOWV6QTJTZmZiampWSWd5eVFvUnF1Nm04MU5nbUV2dFo4L1JSWmF0d2xGRUloN1FwKy80NCsvNmxBTExIZ0RhY3UwaEFGVnhab05rbHE0RStPRVg3c0VuVG9aRFYyK0MxVVFmL0dha3FScHNRPT0iLCJEUCI6Im1zZndvck1jYm0wTlZpelpoLzhERDM4VzBLR0FPVnNPV3pUU3BwOVQ0Y21ZL3lkMlV2cW9kRjZpV2RZZEhzQjA4TzVkMjdtTklIN3hqeVpjMVhsWUVjUnJCZlJVY2crQjZZa0I0QjhEMDQxR3F1SGJIcXY2aHZnSVNiVHI1QUFXQzE3OEZqQitXT095TnVocmpPMGFqd0xBaXRURUlPNFJ6QUdqVjN5VkRWRT0iLCJEUSI6IkhvK3daQ2xnV29CTENQUFJPeGxudHliU2plVEZWQWxVWlFGc01zL2FEQUhUT2wwVHR6SERCeDlxUVVaTVErNnREQnZ3OFpoNWJ2UUJpWGpsUVF4L0VZYzlXN21idFV6YTRZcXdzTVlGaXFZWFJhMXB1Yit5dDFwK1pTM05CaDlOcUErWG9BV0JqYnhxNnh3a2d0a1NHdHRiM2MzMGs0cUg2dmZ2MHRsVWk4OD0iLCJFeHBvbmVudCI6IkFRQUIiLCJJbnZlcnNlUSI6ImNOQWxHSHJUQm5aUjFtWWdRa1FVNCt5N3pMZlo4dHp4dmJXc29RWmxDTDErdnRhVTN0R1pnSHFacjVmU1QrQkc3QUl6dUhYS0dxVjJHd2tKdGtKOTFzUGYwRkoyWjVBTk1YcGpBVjR2RHRIMWU1VjBXblFIOGs2N1p4dUhkQkhuNG81cTVCOFRwWTQ4ditML0gvR2xreGNwazhUVVoxdUhOOVQ1dzR2RTdtQT0iLCJNb2R1bHVzIjoidXpxR2xoVnY0L3gzQnZZTTEyOXd3RThWS3N5RkJJbE5ZMFVmWnk1eFpGVlZ2SkU3SVRSRVhneU93Z3JrYlRBd2RGMnN2TjFic0p3YmxzQytGTVNrRVRjLzNkSG9kMFJraHNWVmFrakVkQTM4eWxyY1BpdTRtVEo5ZUhhZzNscWRkYkZmSVRYcUxHVzlrMDZsWUxPT3ZadkkxQ2JCMnowbWoyTk9lQ0ZBZnRCVlNoZmtuZENxKzQvZXlrTDhDZEMxeHQ5TE9sWmtsTDdJckhRb0lmUUZSNHgzQzJ5MkVidDhwNFBzckhjV1FQWGlxSTA2RmlWZHdWdGxEWVhFaXZwZmRXZit1Z0JKSlpqemc0WHdEQXZEdUlDQXR0MGJ2bG9IYXg5b1ZOU2xDczFrT1U4MlA0MlNESzBuT2xhWEx5N3ZhVjY0WnFRUVQ0T29OQmI4Vk1oMlNRPT0iLCJQIjoiNzJER21jNW9zTCsrcmFrQmJrcGxyUHU4b0ptWWNwdkRidGFSb3diSC9qNnpLVHBGRThYSXRKblRBaUVaWnZtWU1ubklTZjBPbTVpdk92WVJlRlFzdVMwckg3K1hkRUYyT0RsNzdFbDcrdUkrR3FId2NQQ2pkNkZkNmdxcWp6azc4dnRDcldKNVhQTVJCeEp0cEowRXd0am1JUmJhZTRyMmlqNE5BZUptenNzPSIsIlEiOiJ5RHE3c0xXRGtTYU9SaVVQOTZ4VmZodHRiTzNpNVlkZWF5ME1OcXFlMG9Ub0xhb2RPNzZrbE00YXlZY3hSV2VsL0g1WnhCbGMzQ0Y4djh6SVl1Nzc3bk9ZL1hDZUI3NUlsd2p3Q3RGMHBERGhHcWk5a1FSV1JlWGpyNzliNW1xQ2RCRksyUUFyRS95amVMOEM2dE1QQlZYSFJCaTdYOFRyU0hLNW5abjVPTHM9In0="

if aadTenant != "":
    data["Authentication"]["AzureActiveDirectory"]["Authority"] = "https://login.windows.net/" + aadTenant
    data["Authentication"]["AzureActiveDirectory"]["Audience"] = aadClientId
    data["Authentication"]["AzureActiveDirectory"]["Enabled"] = True

f = open(appSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()

os.system("/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentwebnodeinstall \"" + password + "\"")

computeNodeAppSettingsFilePath = "/opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.ComputeNode/appsettings.json"
data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data.pop('configured', None)
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()