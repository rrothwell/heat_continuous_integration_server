#!/bin/bash
# ===========================================
# Install Common Code for Continuous Integration Server
#
# Sets up:
#	Git
#	Gerrit
#	Java
#	DNS
# Resources:
#	https://www.digitalocean.com/community/tutorials/how-to-install-gerrit-on-an-ubuntu-cloud-server
# ===========================================

echo "Install common code for continuous integration server. "

GERRRIT_WAR_NAME="gerrit-2.9.1.war"

# Preparation.
apt-get -y install python-software-properties python-setuptools 

# Download and install Java.

./install_java.sh

# Download and install Gerrit

apt-get -y install git

wget http://gerrit-releases.storage.googleapis.com/gerrit-2.9.1.war

# E.g. http://gerrit-releases.storage.googleapis.com/gerrit-2.9.1.war

wget https://gerrit.googlecode.com/files/$GERRRIT_WAR_NAME

sudo java -jar $GERRRIT_WAR_NAME init --batch -d /usr/local/gerrit
