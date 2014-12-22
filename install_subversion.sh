#!/bin/bash
# ===========================================
# Install Common Code for Subversion Server
#
# Sets up:
#	Subversion.
# Resources:
# 	https://help.ubuntu.com/community/Subversion
#	https://help.ubuntu.com/community/ApacheHTTPserver
#	https://help.ubuntu.com/community/forum/server/apache2/SSL

# To run script standalone:
# ===========================================

# Some of these things may already be done by a driver script.

echo "Install common code for Subversion (SVN) server. "

# Preparation.

sudo apt-get -y update
sudo apt-get -y upgrade

echo "Installing python support. "
apt-get -y install python-software-properties python-setuptools 


# TODO.
# Install Apache
# Install certificate.

# Download and install Subversion

echo "Installing Subversion. "

sudo apt-get install -y subversion

# Subversion user and directory
sudo useradd --create-home --shell /usr/bash --user-group subversion 
echo "subversion:$ACCOUNT_PASSWORD" | chpasswd
sudo passwd 

# Subversion group
sudo adduser www-data subversion # Only needed if publishing the repo via HTTP of HTTPS.

if [ -d /home/jenkins ]; then
    sudo adduser jenkins subversion # Needed for file:/// access by Jenkins.
fi

# Create a repository
sudo mkdir /usr/local/svn
cd /usr/local/svn
sudo mkdir BirdFI
sudo svnadmin create /usr/local/svn/BirdFI

# Adjust permissions
cd /usr/local/svn
sudo chown -R www-data:subversion BirdFI
sudo chmod -R g+rws BirdFI
sudo chown -R www-data:subversion BirdFI
sudo chmod -R g+rws BirdFI

# TODO.
# Configure for WebDav access via HTTPS
# Configure for custom svn protocol with SSL encryption.

echo "Subversion installation complete. "


