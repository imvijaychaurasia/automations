#!/bin/bash

# Install figlet and neofetch
sudo apt update
sudo apt install -y figlet neofetch

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Display welcome message using figlet and neofetch with color
echo -e "${GREEN}"
figlet "Welcome to Aigutech Application Deployment"
echo -e "${NC}"
neofetch

# Display automated installation message using figlet and color
echo -e "${RED}"
figlet -f slant "Automated Installation"
echo -e "We will analyze your system and proceed with the application installation.${NC}"

# Install default JDK
sudo apt install -y default-jdk

# Download Apache Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.90/bin/apache-tomcat-8.5.90.tar.gz

# Create a directory for Apache Tomcat
mkdir ~/tomcat

# Extract Apache Tomcat into the created directory
tar xzf apache-tomcat-8*tar.gz -C ~/tomcat --strip-components=1 >/dev/null 2>&1

# Move the extracted directory to /opt
sudo mv ~/tomcat /opt/

# Update tomcat-users.xml file
sudo sed -i '/<\/tomcat-users>/i \  <role rolename="admin-gui"\/>\n  <role rolename="manager-gui"\/>\n  <user username="aigutechapp" password="aigutechapp1234" roles="admin-gui,manager-gui,manager-script,manager-jmx,manager-status"\/>' /opt/tomcat/conf/tomcat-users.xml

# Remove content of context.xml file in /opt/tomcat/webapps/manager/META-INF
sudo sh -c "echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>' > /opt/tomcat/webapps/manager/META-INF/context.xml"
sudo sh -c "echo '<Context antiResourceLocking=\"false\" privileged=\"true\" >' >> /opt/tomcat/webapps/manager/META-INF/context.xml"
sudo sh -c "echo '  <CookieProcessor className=\"org.apache.tomcat.util.http.Rfc6265CookieProcessor\" sameSiteCookies=\"strict\" />' >> /opt/tomcat/webapps/manager/META-INF/context.xml"
sudo sh -c "echo '  <Manager sessionAttributeValueClassNameFilter=\"java\\.lang\\.(?:Boolean|Integer|Long|Number|String)|org\\.apache\\.catalina\\.filters\\.CsrfPreventionFilter\\$LruCache(?:\\$1)?|java\\.util\\.(?:Linked)?HashMap\"/>' >> /opt/tomcat/webapps/manager/META-INF/context.xml"
sudo sh -c "echo '</Context>' >> /opt/tomcat/webapps/manager/META-INF/context.xml"

# Set permissions for the tomcat user
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin

# Create tomcat.service file
echo -e "[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment=\"JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64\"
Environment=\"JAVA_OPTS=-Djava.security.egd=file:///dev/urandom\"
Environment=\"CATALINA_BASE=/opt/tomcat\"
Environment=\"CATALINA_HOME=/opt/tomcat\"
Environment=\"CATALINA_PID=/opt/tomcat/temp/tomcat.pid\"
Environment=\"CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service >/dev/null

# Reload systemd daemon and enable tomcat service
sudo systemctl daemon-reload
sudo systemctl enable tomcat.service

# Start tomcat service
sudo systemctl start tomcat.service

# Enable and check status of tomcat service
sudo systemctl enable tomcat.service
sudo systemctl status tomcat.service

# Enabling file permission
sudo chmod 777 /opt/tomcat
sudo chmod 777 /opt/tomcat/*

# Allow ports 8080, 80, and 443 in UFW
sudo ufw allow 8080/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Starting Tomcat
/opt/tomcat/bin/startup.sh

# Optional: Clean up downloaded files
rm apache-tomcat-8.5.90.tar.gz

# Fetch machine's local IP
machine_ip=$(hostname -I | awk '{print $1}')

# Display instructions to access the webserver
figlet -f slant "To access the webserver, open a web browser and navigate to:"
echo -e "${RED}"
figlet "http://$machine_ip:8080"
