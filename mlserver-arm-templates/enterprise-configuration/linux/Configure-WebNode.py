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
data["Authentication"]["JWTKey"] = "eyJEIjoiREtJUy9CQlVacGJKaDMwMVpEK3VFanlHdXZvZkt5TTBDRzZvbDUyaVd5VGlRaGVnQnZMRzFTemIxdGhLRzJPYkJSbExHbTRjKzJHZy84TkhiNC9TekVnc0N0OWY4SjhuM2FNajd2QUhhRGRDOHBPNjM1dEhudVl4S0Rhb0FKV2VVQXFQdnFjb1Z1Uy9Ua3RKazRueGRuUU5HTHoycFlqUzRpeWthdDNzTUl4QWI3OVU3L1VvT0Z4ZmJtdnNFazlsejA5RU5TRlp3U2g0QWNIb2FwRVlRK20vSkxWaFV2ZGRCWGFCWjVHUVpFRzNCNThLSGxQNUxpeFZCV0F6WGZiMDFBOXRMWFNNVjJybjFYNjhVWmFNcWF2NlFJOThRVFVQQTJib01NdktwS1FBUE9kc1VlNWVQd29nZGYwd0crYXdhdXFyYzVleXphVVNqVjNUMlZaNVpRPT0iLCJEUCI6InZWc2VRQ0pWbHAxcnV4NWdabTZ6S1Z4YzJuWHNoSnVxYnhyYWVHTEJUZWt1Y3lsQ2l6UHBDQlhsSkpqSTI5Q3Z5emtDTW0yaHBvcGUrSk1oSzBJTnBVWlFVeDlGLzV3QnJXaXJEL1NyNlppUjdvQTEwYkZQVGRjd1BIb2ZTZzlHMC9qUEQ1MHRBZmJDdkNKdkpGbW5hYVhBbHVGSVVTbmtJR1Y5ZHMvMC94VT0iLCJEUSI6InZCRkhVbHNwZXMvaWVKbGVSQ1NWSVhHQzhQSks2WERHZ2piaW5lWVQ0c21VLzVvSG8zZk42bmI0T1FNbWtQUWMrOG1uMWtqc0pCWElUYUZWQWpkbzdqaXQ0SWRXZE5zNlVhenZqOWpPUFozZTRFQllFVjlRTDFleDg4clpUZ1liWVBUbWRDc3d3NTFEczBJcnM0RVhXRkwwdlJDcFhzYjUrbFoxV1NVT3Niaz0iLCJFeHBvbmVudCI6IkFRQUIiLCJJbnZlcnNlUSI6IlNXSFFrV1RhSlo5TE9ZcU54d2FiNkRGYUErZFVwV2d4U1ZlOElDV0JvUEoxNnFMdjIwYi9yY1FEVlowd1hBSk1oRFpxWG44cU9hakMwQVJlL01KOUcrRlNRSVVvYjIvbmVqdWVaMEovSzVXSXNwQkthTW9zR3lGazArYWlwd2JCOUYwSG1FTlFERDl4Wnl5NXRRdkd3eUYxcmhhbzY3eFEyTWIwR0ZrNmdFUT0iLCJNb2R1bHVzIjoic21CeHZJSVVnMVZidGJFN2tJbGFRWUJlMXFkS3VKOTJGK3VKKy94Mzh2RU1OeVhzNUpyY3E3dit4UzlLMnNoSjhpeHBIQUM5WDNxTUFRSVVTY0dIbW5WeEp1OUFEOVdyRE84Z2FGbXpTeUU5V2I4TmdQekpOcnNJUkpvZElvaU9uR2xWWFJGbW5qQXBNK2ZWekJLeWpxaDQ4VC9jMXI0a0VpekRWSmtxMm4rS1lSc0pMaEhPcEwxTGc1T2xxcTZoL3dyTnA2bFE1ZHloR3Z2WlhGQVF1V0N5R2pSV3pHTkV4L1Y1a1VGQTZ2S1RLak10eitkdnNFeWUxRk1yN3ExMWtMbkpZTkRlR0VsMDRzamtOd1FyR1ZuRXNCOVVLb1VNSDQyelJyVjgyYXFGdjFzZlRUREtUVDM1VVVLSlM2OXVMMWxERlBBTlIyVmtLVlcvaUluSWF3PT0iLCJQIjoid0c3aEZkRE90bDdnWURPT1lCb2tnMlRuNTBXa3o1VXFHZlYwY24xNDJlM0gySzdwRDZWeDRMMFNnU3c1VXd3eWZtdllmZHFNNm44VE9wYTRLWlZLZXZERVRFT0JORTd3SVlObzZyZXhJNzJvTWZaN1pJOW5mM0MwQStaT3NBQmlkZS83aGgzQVRKMGJQVXpnc2IvRENmcjd1Qi9wdDA3cEJVNVJLa0U4bmZVPSIsIlEiOiI3VXppdmJYajZuQStmOFhCa2VLL3gwRGRTejBkc0lidCtiZS9tRU5HelJCRGpMT1p0TG1renpDY1lUWTc2aUVtaXQyN3Z3WGVDVEphcXFsZGhxZm9yMlNnU2hOUTFTcmdUWG43cjY3RHVTb1RDUlcxTmFSQStXVVY0WlZuOWpmck56a21xcDlJVkNKWEdvdXlIVE92N0theUwwMm1YMklXREVQUmVITjljTjg9In0="

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