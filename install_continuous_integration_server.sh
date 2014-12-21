#!/bin/bash
# ===========================================
# Install Continuous Integration Server
#
# Sets up:
#	Python
#	Java
#	Jenkins
#   Maybe Subversion
#	DNS (DynDNS is configured manually)
#	Email (not done yet)
#   Configure for Django we applications
#   Configure for Tomcat/Maven web applications
# Resources:
# 	https://wiki.jenkins-ci.org/display/JENKINS/Meet+Jenkins
# 	https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins
# 	https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
# To run script standalone:
# export PROJECT_NAME=JenkinsTest; export BASE_DOMAIN=V3.org;export JENKINS_ACCOUNT_PASSWORD=fuzzyface;./install_jenkins.sh
# ===========================================

# Log messages echoed will appear in /var/log/cloud-init.log

echo "Continuous Integration Server. "

# Preparation.

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.
echo "Installing java support. "

./install_java.sh

# Download and install Jenkins

echo "Installing Jenkins. "

./install_jenkins.sh


