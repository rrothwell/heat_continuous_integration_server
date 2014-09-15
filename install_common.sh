#!/bin/bash
# ===========================================
# Install Common Code for Continuous Integration Server
#
# Sets up:
#	Git
#	Java
#	Gerrit with H2 database and default encryption level.
#	DNS
# Resources:
#	https://www.digitalocean.com/community/tutorials/how-to-install-gerrit-on-an-ubuntu-cloud-server
# ===========================================

echo "Install common code for continuous integration server. "

GERRIT_WAR_NAME="gerrit-2.9.1.war"

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

adduser gerrit2
mkdir /usr/local/gerrit
chown -R gerrit2:gerrit2 /usr/local/gerrit
su gerrit2

wget http://gerrit-releases.storage.googleapis.com/$GERRIT_WAR_NAME

java -jar $GERRIT_WAR_NAME init --batch -d /usr/local/gerrit

# To check:
# git config -f /usr/local/gerrit/etc/gerrit.config gerrit.canonicalWebUrl

echo "Configure Gerrit. "

# Change port away from default Tomcat port.
git config -f /usr/local/gerrit/etc/gerrit.config --replace-all gerrit.canonicalWebUrl http://localhost:8085/
git config -f /usr/local/gerrit/etc/gerrit.config --replace-all httpd.listenUrl http://*:8085/

# Set Gerrit for restart on server boot.
echo "Setup Gerrit for reboot. "

# 1. Tweak gerrit.sh control script.
sed -i 's/# chkconfig: 3 99 99/chkconfig: 3 99 99/' /usr/local/gerrit/bin/gerrit.sh
sed -i 's/# description: Gerrit Code Review/description: Gerrit Code Review/' /usr/local/gerrit/bin/gerrit.sh
sed -i 's/# processname: gerrit/processname: gerrit/' /usr/local/gerrit/bin/gerrit.sh
# 2. Obtain root privileges again.
exit
# 3. Tie in to the startup script mechanism.
ln -snf `pwd`/usr/local/gerrit/bin/gerrit.sh /etc/init.d/gerrit
ln -snf /etc/init.d/gerrit /etc/rc3.d/S90gerrit
# 4. Impose changes by restarting server.
/usr/local/gerrit/bin/gerrit.sh restart

echo "Installation complete. "
echo "Complete the process by logging in at http://localhost:8085/ and creating a superadmin account. "
echo "Visit http://gerrit-review.googlesource.com/Documentation/install.html for instructions. "


