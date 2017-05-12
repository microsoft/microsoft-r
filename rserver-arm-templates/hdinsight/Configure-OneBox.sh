#!/bin/bash

rm /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.WebAPI/appsettings.json
wget -O /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.WebAPI/appsettings.json https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/hdinsight/WebAPI/appsettings.json 

rm /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.BackEnd/appsettings.json
wget -O /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.BackEnd/appsettings.json https://raw.githubusercontent.com/Microsoft/microsoft-r/master/rserver-arm-templates/hdinsight/BackEnd/appsettings.json 

cp /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.WebAPI/autoStartScriptsLinux/* /etc/systemd/system/.
cp /usr/lib64/microsoft-deployr/9.0.1/Microsoft.DeployR.Server.BackEnd/autoStartScriptsLinux/* /etc/systemd/system/.

systemctl enable frontend
systemctl enable rserve
systemctl enable backend

systemctl start frontend
systemctl start rserve
systemctl start backend