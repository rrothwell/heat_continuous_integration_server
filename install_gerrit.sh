#!/bin/bash
# ===========================================
# Install Common Code for Continuous Integration Server
#
# Sets up:
#	Python
#	Git
#	Java
#	Gerrit with H2 database and default encryption level.
#	DNS (DynDNS is configured manually)
#	Email (not done yet)
#	Jenkins (not done yet)
# Resources:
#	http://gerrit-review.googlesource.com/Documentation/install-quick.html
#	http://gerrit-review.googlesource.com/Documentation/install.html
#	https://www.digitalocean.com/community/tutorials/how-to-install-gerrit-on-an-ubuntu-cloud-server
#	http://dachary.org/?p=1716 (Gerrit and Jenkins)
# To run script standalone:
# export PROJECT_NAME=GerritTest; export BASE_DOMAIN=V3.org;export GERRIT_ACCOUNT_PASSWORD=fuzzyface;export IP_ADDRESS=130.56.252.24;./install_common.sh
# ===========================================

echo "Install common code for continuous integration server. "

GERRIT_WAR_NAME="gerrit-2.9.1.war"
GERRIT_CONFIG="/usr/local/gerrit/etc/gerrit.config"
GERRIT_SCRIPT="/usr/local/gerrit/bin/gerrit.sh"

echo $GERRIT_WAR_NAME

# Preparation.

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.
echo "Installing java support. "

./install_java.sh

# Download and install Gerrit
echo "Installing Git. "

apt-get -y install git

echo "Installing Gerrit. "

# E.g. http://gerrit-releases.storage.googleapis.com/gerrit-2.9.1.war

useradd -m -s /bin/bash gerrit2
echo "gerrit2:$GERRIT_ACCOUNT_PASSWORD" | chpasswd

mkdir /usr/local/gerrit
wget http://gerrit-releases.storage.googleapis.com/$GERRIT_WAR_NAME
java -jar $GERRIT_WAR_NAME init --batch --site-path /usr/local/gerrit

chown -R gerrit2:gerrit2 /usr/local/gerrit

# To check:
# git config -f /usr/local/gerrit/etc/gerrit.config gerrit.canonicalWebUrl

echo "Configure Gerrit. "

# Start execute block of commands as gerrit2 user.

# Change port away from default Tomcat port.
# This does not work so connections to port 8085 fail.
# Failures probably due to local organisation's proxy.
# The ssh connection to port 29418 can also be blocked by the local proxy.
#sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all gerrit.canonicalWebUrl http://localhost:8085/
#sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all httpd.listenUrl http://*:8085/

# OpenID needs a real URL. localhost doesn't cut it.
# OpenID to Google is broken due to Google's deprecation policy from May 22 2014.
# Use Yahoo OpenID instead until Gerrit is updated to new version.
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all gerrit.canonicalWebUrl http://$DOMAIN_NAME:8080/
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all httpd.listenUrl http://$DOMAIN_NAME:8080
sudo -u gerrit2 git config -f /usr/local/gerrit/etc/gerrit.config --replace-all container.user gerrit2

# Set Gerrit for restart on server boot.
echo "Setup Gerrit for reboot. "

# 1. Tweak gerrit.sh control script.
# Ubuntu complains about this. Seems it has removed chkconfig,
# See: http://askubuntu.com/questions/221293/why-is-chkconfig-no-longer-available-in-ubuntu
apt-get install chkconfig
sudo -u gerrit2 sed -i 's/# chkconfig: 3 99 99/chkconfig: 3 99 99/' $GERRIT_SCRIPT
sudo -u gerrit2 sed -i 's/# description: Gerrit Code Review/description: Gerrit Code Review/' $GERRIT_SCRIPT
sudo -u gerrit2 sed -i 's/# processname: gerrit/processname: gerrit/' $GERRIT_SCRIPT

# Finish execute block of commands as gerrit2 user.

# 3. Tie in to the startup script mechanism.
ln -snf `pwd`/usr/local/gerrit/bin/gerrit.sh /etc/init.d/gerrit
ln -snf /etc/init.d/gerrit /etc/rc3.d/S90gerrit

# 4. Impose changes by restarting server.

echo "Restart Gerrit to notice changed settings. "

$GERRIT_SCRIPT restart

echo "Installation complete. "
echo "Complete the process by logging in at http://$DOMAIN_NAME:8080/ and creating a superadmin account. "
echo "Visit http://gerrit-review.googlesource.com/Documentation/install.html for instructions. "


