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
# To run script standalone:
# export PROJECT_NAME=JenkinsTest; export BASE_DOMAIN=V3.org;export JENKINS_ACCOUNT_PASSWORD=fuzzyface;./install_jenkins.sh
# ===========================================

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
sudo apt-get update
sudo apt-get install jenkins

echo "Configuring Jenkins. "

# TODO.

echo "Installation complete. "
echo "Complete the process by logging in at http://$DOMAIN_NAME:8080/ and creating a superadmin account. "
echo "Visit https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins for instructions. "


