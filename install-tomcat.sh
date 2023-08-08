#!/bin/bash
#update the system
sudo apt update

#Install necessary packages
sudo apt install -y default-jdk wget

# Download Tomcat
cd /opt
sudo systemctl stop tomcat
sudo rm -rf apache* tomcat*
sudo mkdir -p /opt/tomcat

sudo wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
sudo tar xvzf apache-tomcat-9.0.78.tar.gz
sudo rm -rf apache*.tar.gz

# Configuring Tomcat server for Manager, Host-manager and Credentials
cd -
sudo cp /context.xml /opt/tomcat/apache-tomcat-9.0.78/webapps/manager/META-INF/context.xml
sudo cp /context.xml /opt/tomcat/apache-tomcat-9.0.78/webapps/host-manager/META-INF/context.xml
sudo cp /tomcat-users.xml /opt/tomcat/apache-tomcat-9.0.78/conf/tomcat-users.xml
# Configuring Tomcat as a Service
sudo cp /tomcat.service /etc/systemd/system/tomcat.service

sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
sudo chown -R tomcat: /opt/tomcat/*
sudo chmod +x /opt/tomcat/apache-tomcat-9.0.78/bin/*.sh

sudo systemctl daemon-reload
sudo systemctl start tomcat

sudo ufw allow 8080

sudo systemctl is-active --quiet tomcat
echo "\n --------------------------------------------------------------------- \n"
if [$? = 0]; then
    echo "Tomcat installed successfully"
    echo "Access Tomcat using http://$(curl -s ifconfig.me):8080"
else
    echo "Tomcat Installation failed"
fi
echo "\n --------------------------------------------------------------------- \n"


 