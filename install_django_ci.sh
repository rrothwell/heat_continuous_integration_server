#!/bin/bash
# ===========================================
# Django/Python Continuous Integration
#
# Sets up:
#	Django/Python dependencies with unit testing code coverage and style checking.
# Resources:
#   http://michal.karzynski.pl/blog/2014/04/19/continuous-integration-server-for-django-using-jenkins/
# 	https://sites.google.com/site/kmmbvnr/home/django-jenkins-tutorial
#   http://shiningpanda.com/multi-browser-selenium-tests-django-14-jenkins.html

# To run script standalone:
# ===========================================

# Install virtual environment for Jenkins build process.
apt-get install -y python-virtualenv
apt-get install -y gettext

# Install Numpy and dependencies
sudo apt-get install -y python-numpy python-scipy cython

echo "Configuring Django. "

mkdir -p /var/lib/jenkins/jobs/$PROJECT_NAME

####### Project configuration file

wget --no-cache -O /var/lib/jenkins/jobs/django_config.xml https://raw.githubusercontent.com/rrothwell/heat_continuous_integration_server/master/django_config.xml
chown jenkins:jenkins /var/lib/jenkins/jobs/django_config.xml

#PROJECT_NAME=VU_Bird_Flight; cp /var/lib/jenkins/jobs/django_config.xml /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml
cp /var/lib/jenkins/jobs/django_config.xml /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml

# PROJECT_NAME=VU_Bird_Flight; SVN_REPO_URL=https://svn.vpac.org/BirdFI/trunk/BirdFI; sed -i 's%${repourl}%'"$SVN_REPO_URL%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml
sed -i 's%${repourl}%'"$SVN_REPO_URL%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml

# PROJECT_NAME=VU_Bird_Flight; SVN_PROJECT=BirdFI; sed -i 's%${svnproject}%'"$SVN_PROJECT%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml
sed -i 's%${svnproject}%'"$SVN_PROJECT%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml

# PROJECT_NAME=VU_Bird_Flight; DJANGO_APP=BirdFI; sed -i 's%${djangoapp}%'"$DJANGO_APP%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml
sed -i 's%${djangoapp}%'"$DJANGO_APP%" /var/lib/jenkins/jobs/$PROJECT_NAME/config.xml

####### Project credentials file.

wget --no-cache -O /var/lib/jenkins/jobs/$PROJECT_NAME/django_subversion.credentials https://raw.githubusercontent.com/rrothwell/heat_continuous_integration_server/master/django_subversion.credentials
chown jenkins:jenkins /var/lib/jenkins/jobs/django_subversion.credentials

# Jenkins will automagically encrypt the password, so we substitute that in a temporary file
# before we move the credentials file into the jobs/$PROJECT_NAME directory.

#PROJECT_NAME=VU_Bird_Flight; cp /var/lib/jenkins/jobs/django_subversion.credentials /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials.tmp
cp /var/lib/jenkins/jobs/django_subversion.credentials /var/lib/jenkins/jobs/$PROJECT_NAME/django_subversion.credentials.tmp

# PROJECT_NAME=VU_Bird_Flight; SVN_PASSWORD=monkeyblood#7t; sed -i 's%${password}%'"$SVN_PASSWORD%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials.tmp
sed -i 's%${password}%'"$SVN_PASSWORD%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials.tmp

#PROJECT_NAME=VU_Bird_Flight; mv /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials.tmp /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials
mv /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials.tmp /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials
touch /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials

# PROJECT_NAME=VU_Bird_Flight; SVN_ROOT_URL=https://svn.vpac.org:443; sed -i 's%${realm}%'"$SVN_ROOT_URL%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentialsq
sed -i 's%${realm}%'"$SVN_ROOT_URL%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials

# PROJECT_NAME=VU_Bird_Flight; SVN_USERNAME=jenkins; sed -i 's%${username}%'"$SVN_USERNAME%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials
sed -i 's%${username}%'"$SVN_USERNAME%" /var/lib/jenkins/jobs/$PROJECT_NAME/subversion.credentials


