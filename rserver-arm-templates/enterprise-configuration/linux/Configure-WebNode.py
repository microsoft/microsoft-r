#!/usr/bin/python

import sys
import json
import os
import subprocess
import time
from collections import OrderedDict

linuxOS=sys.argv[1]
password=sys.argv[2]
aadTenant=sys.argv[3]
aadClientId=sys.argv[4]
sqlServerConnectionString=sys.argv[5]

if linuxOS == "Ubuntu":
    os.system("apt-get install -y nginx")
    os.system("sed -i 's%# pass the PHP scripts%location /ping { return 200 \"hello\"; }#%g' /etc/nginx/sites-enabled/default")
    os.system("service nginx start")
    os.system("update-rc.d nginx defaults")
elif linuxOS == "RedHat":
    os.system("yum clean all")    
    os.system("yum makecache fast")    
    os.system("yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm")    
    os.system("yum install -y nginx")
    os.system("sed -i 's#location / {#location /ping { return 200 \"hello\";#g' /etc/nginx/nginx.conf")
    os.system("systemctl start nginx")
    os.system("systemctl enable nginx")
else:
    os.system("yum install -y epel-release")
    os.system("yum install -y nginx")
    os.system("sed -i 's#location / {#location /ping { return 200 \"hello\";#g' /etc/nginx/nginx.conf")
    os.system("systemctl start nginx")
    os.system("systemctl enable nginx")

os.environ["HOME"] = "/root"

p = subprocess.Popen(["/usr/local/bin/dotnet", "restore"], cwd=".")
p.wait()
p = subprocess.Popen(["/usr/local/bin/dotnet", "run"], cwd=".")
p.wait()

appSettingsFilePath = "/usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.WebNode/appsettings.json"
data = json.loads(open(appSettingsFilePath, "r").read().decode("utf-8-sig").encode("utf-8").replace("\r\n",""), object_pairs_hook=OrderedDict)

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

f = open(appSettingsFilePath, "w")
json.dump(data, f, indent=4, sort_keys=False)
f.close()

time.sleep(10)
os.system("/usr/local/bin/dotnet /usr/lib64/microsoft-r/rserver/o16n/9.1.0/Microsoft.RServer.Utils.AdminUtil/Microsoft.RServer.Utils.AdminUtil.dll -silentwebnodeinstall \"" + password + "\"")