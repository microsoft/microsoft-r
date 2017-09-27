#!/bin/bash

password=$1

if [ -f /etc/debian_version ]; then
  apt-get update
  apt-get -y install apt-transport-https
  curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > ./microsoft-prod.list
  cp ./microsoft-prod.list /etc/apt/sources.list.d/
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
  apt-get update
  apt-get -y install microsoft-mlserver-all-9.2.1
  /opt/microsoft/mlserver/9.2.1/bin/R/activate.sh -l 
else 
  yum-config-manager --add-repo http://packages.microsoft.com/config/rhel/7/prod.repo
  yum -y install microsoft-mlserver-all-9.2.1
  /opt/microsoft/mlserver/9.2.1/bin/R/activate.sh -l
  iptables --flush
fi
 
/usr/local/bin/dotnet /opt/microsoft/mlserver/9.2.1/o16n/Microsoft.MLServer.Utils.AdminUtil/Microsoft.MLServer.Utils.AdminUtil.dll -silentoneboxinstall "$password"