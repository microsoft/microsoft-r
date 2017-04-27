#!/bin/bash

password=$1
cd /usr/lib64/microsoft-r/rserver/o16n/9.1.0
dotnet Microsoft.RServer.Utils.AdminUtil/Microsoft.RServer.Utils.AdminUtil.dll -silentoneboxinstall "$password"