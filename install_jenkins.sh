#!/bin/bash
# ===========================================
# Install Common Code for Jenkins Server
#
# Sets up:
#	Python
#	Git
#	Java
#	Jenkins.
#	DNS (DynDNS is configured manually)
#	Email (not done yet)
# Resources:
# To run script standalone:
# export PROJECT_NAME=JenkinsTest; export BASE_DOMAIN=V3.org;export JENKINS_ACCOUNT_PASSWORD=fuzzyface;export IP_ADDRESS=130.56.252.24;./install_jenkins.sh
# ===========================================

echo "Install common code for Jenkins server. "

JENKINS_WAR_NAME="gerrit-2.9.1.war"
JENKINS_CONFIG="/usr/local/gerrit/etc/gerrit.config"
JENKINS_SCRIPT="/usr/local/gerrit/bin/gerrit.sh"

echo $JENKINS_WAR_NAME

# Preparation.

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.
echo "Installing java support. "

./install_java.sh

# Download and install Jenkins
echo "Installing Git. "

apt-get -y install git

echo "Installing Jenkins. "

# E.g. http://gerrit-releases.storage.googleapis.com/gerrit-2.9.1.war

useradd -m -s /bin/bash gerrit2
echo "gerrit2:$JENKINS_ACCOUNT_PASSWORD" | chpasswd

mkdir /usr/local/gerrit
wget http://gerrit-releases.storage.googleapis.com/$JENKINS_WAR_NAME
java -jar $JENKINS_WAR_NAME init --batch --site-path /usr/local/gerrit

chown -R gerrit2:gerrit2 /usr/local/gerrit

# To check:
# git config -f /usr/local/gerrit/etc/gerrit.config gerrit.canonicalWebUrl

echo "Configure Jenkins. "

# Start execute block of commands as gerrit2 user.

# Change port away from default Tomcat port.
# This does not work so connections to port 8085 fail.
# Failures probably due to local organisation's proxy.
# The ssh connection to port 29418 can also be blocked by the local proxy.
#sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all gerrit.canonicalWebUrl http://localhost:8085/
#sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all httpd.listenUrl http://*:8085/

# OpenID needs a real URL. localhost doesn't cut it.
# OpenID to Google is broken due to Google's deprecation policy from May 22 2014.
# Use Yahoo OpenID instead until Jenkins is updated to new version.
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all gerrit.canonicalWebUrl http://$DOMAIN_NAME:8080/
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all httpd.listenUrl http://$DOMAIN_NAME:8080
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all container.user gerrit2

# Set Jenkins for restart on server boot.
echo "Setup Jenkins for reboot. "

# 1. Tweak gerrit.sh control script.
# Ubuntu complains about this. Seems it has removed chkconfig,
# See: http://askubuntu.com/questions/221293/why-is-chkconfig-no-longer-available-in-ubuntu
apt-get install chkconfig
sudo -u gerrit2 sed -i 's/# chkconfig: 3 99 99/chkconfig: 3 99 99/' $JENKINS_SCRIPT
sudo -u gerrit2 sed -i 's/# description: Jenkins Code Review/description: Jenkins Code Review/' $JENKINS_SCRIPT
sudo -u gerrit2 sed -i 's/# processname: gerrit/processname: gerrit/' $JENKINS_SCRIPT

# Finish execute block of commands as gerrit2 user.

# 3. Tie in to the startup script mechanism.
ln -snf `pwd`/usr/local/gerrit/bin/gerrit.sh /etc/init.d/gerrit
ln -snf /etc/init.d/gerrit /etc/rc3.d/S90gerrit

# 4. Impose changes by restarting server.

echo "Restart Jenkins to notice changed settings. "

$JENKINS_SCRIPT restart

echo "Installation complete. "
echo "Complete the process by logging in at http://$DOMAIN_NAME:8080/ and creating a superadmin account. "
echo "Visit http://gerrit-review.googlesource.com/Documentation/install.html for instructions. "


