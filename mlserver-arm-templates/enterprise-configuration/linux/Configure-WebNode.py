#!/usr/bin/python

import sys
import json
import os
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

if aadTenant != "":
    data["Authentication"]["AzureActiveDirectory"]["Authority"] = "https://login.windows.net/" + aadTenant
    data["Authentication"]["AzureActiveDirectory"]["Audience"] = aadClientId
    data["Authentication"]["AzureActiveDirectory"]["Enabled"] = True

f = open(webNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

os.system("/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentwebnodeinstall \"" + password + "\"")

data = json.loads(open(webNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data["Authentication"]["JWTKey"] = "eyJEIjoiSktHcTJablpCSjZiMCt4bWZiSFg0VnZHbEovTWJ6R3FmYlNuUzJva29hZUZCV3lZQ1dXWFBKWTZvNjF3aDVWaSt3YnVydXMwR1BMbk1salZZS3UvYldMWEhuUWtIUk9qMEtGek9lcFlUWVJCajZ6VFJ5MCt0cGRnaERCaTNCellTZEFKTXNodjAvREpxdENIVm9aRTcyNHZpSERsNFVzRlhjQStjRi9pclRiSjFMMnlmVVZtekVJM1FuN0Q3SXFtK0ZIVlhTc2dOeFZQVXpYd0M3Z1hBc2M3dDNVRWtRc2x0cmFiNWtadkNKRkJ0eDEwbGlSSVRwekl4b2F0bXZMUEhpVGVmZGtvUkIrZjZXbXhOcHJ3cUxVSVQrYitKZHc2Q3dUOXVmREhOejd0YVpMdC9FalRkVU40MndCNjIvZDAxR2Z4cnRuNVp3bUpwU29zcXZvY2VRPT0iLCJEUCI6Im5ING15MVVPV3pFYVQyWGliMlRoaWJPUkRYTStpYnJwMkd0c2VMeUhQdjNGdDZYTm8rQVEzb3hRS2UrN0MyeFhIbWZxSElJSE1iY2xCTWxaS2F1ZUVmTDU0a01WeU1heit0VWVqa2dIZjkvRi9CNzNlejFuZGpzUGhpSEs1MnVqdnFtUWZFa2h6U0s1RXZNOHVDQ3h5QlI3aGpyY1RBWTVvMFNMSk1OOU05MD0iLCJEUSI6Ik1aUWd1UCt3QzNnYjdTTVBKM2laeEk5eHg3RS91cDBqVkhnSms1WUhrNHBuL3RYNy9KMkdMWER0U0VVTmNFckhudHdVL3UzUGNsMXM3Ynh5TWFtNS9nZmhVSTFib1Y2MW9PYU9BdEtXYzVmckdOcWZPNnVVdnhudEZHa3NXOWtWRlk4dm5IYVYva2tnajlzUE56OUdFT2FkLzBrRWNKRkpVY1dwQWZyejRhMD0iLCJFeHBvbmVudCI6IkFRQUIiLCJJbnZlcnNlUSI6Ik50K3g5VnN5dnlqTkRTZGJGZlB4SnpSRVBTOG1GblJ1cEplb3VkMC9ITThoU0U3aVV2ZXkvYjF6ZWhCNkhaWDF0K3dKQk1nTVlkNDZ3aUM1c0FiV0NSWDJEV05hZlMzMHJYZE53YVd4UGJVZmVhaFZHMURBVTI1WnEzNHY4bWczTTU3TElhdWdrallwbXZXdGpjTEZwMkFkOStmdmJobmRKQW9PeGJGdWl1az0iLCJNb2R1bHVzIjoidGo3V3BudUlWaDl6ME5IR2VtWmVVTXh3OU5VL1BMR0FUdlkraWZmZ3EwQ3JSSnpscXN1amRkRHFvL3Vtbi9uOGpJRCt4ZFV3R2ZHcEo5dnMrL1hSazFUK1M2a1FqODMweGNnbEVURERiQ2pLOXRDOGdiL2Qzd3JPcGtEWjVuVlpNYWpOSG52L3NrYjIxc2p5ZzVqcHlBMkJkY0hSaExENTJzSHB2YkxVYm44RWx3QW9RZ2JRcEZWWHZiWnMrd2V5MXU3Mmc5YUpoUE1EV2xndllMcjJ5NkZrOWc4bjAyKzk3OHVCeldDUkNyRjJtTHFXWEFZWjNKTmVpM3VRc21uMkNmVmg5L0lwcjRLWXU5dUZzMjNzcytxYlZLdHk3QzZlVW12c3h0SGt2TnJ3OWRjS2xtL2JEaTJLRU9rZS9TRjFqdWlrREMyNGs5T1hkQVo2RDUvVGl3PT0iLCJQIjoiNGU4MmVZcTY4SittMm5uTkhjTHd6SlhOREE4WFhVWkJNR0lGRGN6RlJIVkloVmFCajNIcE95cEhIWnRaL1pVenRRNkUzb2t5Uk9mTW9vdEl6UEc3QnIxT1lvbjg0dDU0d3dzSEJnRDFIWDJVY1ZCL0E2WHJHL1BPVlhyWWZ4VjFrd0hFR0tSN2hLSU1BcVFib1VsblE0cFArOHVMVXRCRDZIdjRWbTlLT1Q4PSIsIlEiOiJ6bjlNRS94T3V3RHpOMWsxejg1TStUUHI0SHlNc2pKLzN5QVpzeHFtNnU1R1p1TkQ1dmc0Um9laVRxOC8raVdFRmYzUlNtRitJOWJzcEZnTW1DYVY1eU5nSEZvemJHQmRMMlZiZVJwMVowU3ZSR2lVM3M2cFYvcmNucEQ1TXlBMllndFBYMzBhYzdvRnhuOWY4aTNOdXU1VVo0WFlLbVROd3NjVitXVGFKclU9In0="
f = open(webNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()

os.system("service webnode restart")

data = json.loads(open(computeNodeAppSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)
data.pop('configured', None)
f = open(computeNodeAppSettingsFilePath, "w")
json.dump(data, f, indent=2, sort_keys=False)
f.close()