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

# Log messages echoed will appear in /var/log/cloud-init-output.log

echo "Install Continuous Integration Server: Begin! "

# Preparation.

# Silence complaints
chmod 0440 /etc/sudoers.d/heat-instance-ec2-user
echo -e "$IP_ADDRESS\t$HOSTNAME\t$DOMAIN_NAME"  >> /etc/hosts;

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.

./install_java.sh

# Download and install Jenkins
																	
./install_jenkins.sh
if [ $INSTALL_SVN = "Yes" ]; then

    # Download and install Subversion
	./install_subversion.sh
	
fi

echo "Install Continuous Integration Server: End! "

