#!/bin/bash
# ===========================================
# Install Common Code for Jenkins Server
#
# Sets up:
#	Python
#	Java
#	Jenkins.
#	DNS (DynDNS is configured manually)
#	Email (not done yet)
# Resources:
# 	https://wiki.jenkins-ci.org/display/JENKINS/Meet+Jenkins
# 	https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins
# 	https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
#   https://www.okta.com/blog/2012/04/simple-jenkins-configuration-and-deployment/#
# To run script standalone:
# export PROJECT_NAME=JenkinsTest; export BASE_DOMAIN=V3.org;export JENKINS_ACCOUNT_PASSWORD=fuzzyface;./install_jenkins.sh
# ===========================================

# Some of these things may already be done by a driver script.

echo "Install common code for Jenkins server. "

# Preparation.

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.
echo "Installing java support. "

./install_java.sh

# Download and install Jenkins

echo "Installing Jenkins. "

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -y update
sudo apt-get install -y jenkins

echo "Configuring Jenkins. "

wget --no-cache -O /var/lib/jenkins/config.xml https://raw.githubusercontent.com/rrothwell/heat_continuous_integration_server/master/jenkins_config.xml
chown jenkins:jenkins /var/lib/jenkins/config.xml
service jenkins restart

cd /var/lib/jenkins

regex='200 OK'
while true; do
    status=$( wget http://localhost:8080 2>&1 )
    if [[ "$status" =~ $regex ]]; then
        echo ">>>>>>$status<<<<<<<<"
        break
    fi
    echo "Waiting for Jenkins to restart."
    sleep 5
done
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

# Running Jenkins CLI script as anonymous initially
# Need the Jenkins config.xml file to have anonymous script execution temporarily.
#JENKINS_ADMIN_PASSWORD=monkeyblood#7t; echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"jenkins_admin\", \"$JENKINS_ADMIN_PASSWORD\")" | java -jar jenkins-cli.jar -s http://localhost:8080/ groovy =
echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"jenkins_admin\", \"$JENKINS_ADMIN_PASSWORD\")" | java -jar jenkins-cli.jar -s http://localhost:8080/ groovy =
sed -i 's%<permission>hudson.model.Hudson.RunScripts:anonymous</permission>%%' /var/lib/jenkins/config.xml
service jenkins restart

echo "Installation complete. "
echo "Complete the process by navigating to: http://$DOMAIN_NAME:8080/login?from=%2Fmanage and create an admin account with user name 'jenkins-admin.' "
echo "Visit https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins for instructions. "
echo "Comply with the Standard Security Setup: https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup"


