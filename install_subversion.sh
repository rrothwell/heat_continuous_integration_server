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
#	http://odyniec.net/articles/ubuntu-subversion-server/

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

echo "Installing latest Subversion 1.7: Begin! "

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key A2F4C039
sudo apt-add-repository -y ppa:svn/ppa
sudo apt-get  -y update
sudo apt-get  -y upgrade

# Needed if upgrading Subversion.
#sudo apt-get dist-upgrade

# Only needed if not already installed.
sudo apt-get install -y subversion

# Subversion user/group and directory
echo -e "Adding the subversion application user: subversion:$SVN_ACCOUNT_PASSWORD"
sudo useradd --create-home --shell /bin/bash --user-group subversion
echo "subversion:$SVN_ACCOUNT_PASSWORD" | chpasswd

# Subversion group
sudo adduser www-data subversion # Only needed if publishing the repo via HTTP of HTTPS.

# Needed for file:/// access by Jenkins.
# If Jenkins is installed on the same server.
if [ -d /home/jenkins ]; then
    sudo adduser jenkins subversion 
fi

# Create a repository area
sudo mkdir /usr/local/svn
sudo mkdir /usr/local/svn/repos

# Create a repository
cd /usr/local/svn/repos
sudo mkdir $PROJECT_NAME
umask 002
sudo svnadmin create /usr/local/svn/repos/$PROJECT_NAME
umask 022

# Activate allow everything pre-revprop-change hook.
# Not recommended in general but we need it to get "svnrdump load" to work.
echo -e "#!/bin/sh\nexit 0\n"  >> /usr/local/svn/repos/$PROJECT_NAME/hooks/pre-revprop-change;
sudo chmod u+x /usr/local/svn/repos/$PROJECT_NAME/hooks/pre-revprop-change


# Adjust permissions twice.
# www-data is there for when we setup WebDAV.
cd /usr/local/svn/repos
sudo chown -R www-data:subversion .
sudo chmod -R g+rws .
sudo chown -R www-data:subversion .
sudo chmod -R g+rws .

# Add one repo user.
echo -e "Adding a repository user: $SVN_USERNAME\t$SVN_PASSWORD"
sudo useradd --create-home --shell /bin/bash --user-group $SVN_USERNAME
echo "$SVN_USERNAME:$SVN_PASSWORD" | chpasswd
sudo adduser $SVN_USERNAME subversion # Only needed if publishing the repo via HTTP of HTTPS.

# TODO.
# Configure for WebDav access via HTTPS

# Configure for custom svn protocol.

# Setting it up for common authentication to all repositories.
sed -i 's%# anon-access = read%anon-access = none%' /usr/local/svn/repos/$PROJECT_NAME/conf/svnserve.conf
sed -i 's%# password-db = passwd%password-db = /usr/local/svn/passwd%' /usr/local/svn/repos/$PROJECT_NAME/conf/svnserve.conf
sed -i 's%# realm = My First Repository%realm = Developers%' /usr/local/svn/repos/$PROJECT_NAME/conf/svnserve.conf

# Give one repo user access.
# Plain text passwords so we need something better: SASL or SSH tunnelling.
echo -e "[users]"  >> /usr/local/svn/passwd;
echo -e "$SVN_USERNAME = $SVN_PASSWORD"  >> /usr/local/svn/passwd;
sudo chmod 600 /usr/local/svn/passwd


# TODO
# Configure for custom svn protocol with SSL encryption.

# TODO
# svnserve init script.

svnserve -d -r /usr/local/svn/repos --log-file /var/log/svn.log &

# Advise manual execution.
echo -e "Run this command after SSH-ing into the server.";
echo -e "svnserve -d -r /usr/local/svn/repos --log-file /var/log/svn.log &"
echo -e "Set auth-access = none once the need for the svn protocol connection is not needed."

echo "Installing latest Subversion 1.7: End! "


