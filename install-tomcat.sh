#!/bin/bash
#update the system
sudo apt update

#Install necessary packages
sudo apt install -y default-jdk wget

# Download Tomcat
cd /opt
sudo rm -rf apache* tomcat*
sudo mkdir -p /opt/tomcat

sudo wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz
sudo tar -xf apache-tomcat-9.0.78.tar.gz  -C /opt/tomcat
sudo rm -rf apache-tomcat-9.0.78.tar.gz

# Configuring Tomcat server for Manager, Host-manager and Credentials
cd -
sudo cp context.xml /opt/tomcat/apache-tomcat-9.0.78/webapps/manager/META-INF/context.xml
sudo cp context.xml /opt/tomcat/apache-tomcat-9.0.78/webapps/host-manager/META-INF/context.xml
sudo cp tomcat-users.xml /opt/tomcat/apache-tomcat-9.0.78/conf/tomcat-users.xml

# Configuring Tomcat as a Service
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
sudo chown -R tomcat: /opt/tomcat/*
sudo cp tomcat.service /etc/systemd/system/tomcat.service
sudo rm -rf tomcat-ubuntu

sudo systemctl daemon-reload
sudo systemctl start tomcat

sudo ufw allow 8080

#checking for Tomcat status
sudo systemctl is-active --quiet tomcat

echo "\n --------------------------------------------------------------------- \n"
if [ $? -eq 0 ]; then
    echo "Tomcat installed successfully"
    echo "Access Tomcat using http://$(curl -s ifconfig.me):8080"
else
    echo "Tomcat Installation failed"
fi
echo "\n --------------------------------------------------------------------- \n"


 