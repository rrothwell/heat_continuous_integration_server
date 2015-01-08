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

####### Project configuration file.

wget --no-cache -O /var/lib/jenkins/jobs/django_config.xml https://raw.githubusercontent.com/rrothwell/heat_continuous_integration_server/master/django_config.xml
chown jenkins:jenkins /var/lib/jenkins/jobs/django_config.xml

#PROJECT_NAME=VU_Bird_Flight; cp /var/lib/jenkins/jobs/django_config.xml /var/lib/jenkins/jobs/tmp_config.xml
cp /var/lib/jenkins/jobs/django_config.xml /var/lib/jenkins/jobs/tmp_config.xml

# PROJECT_NAME=VU_Bird_Flight; SVN_REPO_URL=https://svn.vpac.org/BirdFI/trunk/BirdFI; sed -i 's%${repourl}%'"$SVN_REPO_URL%" /var/lib/jenkins/jobs/tmp_config.xml
sed -i 's%${repourl}%'"$SVN_REPO_URL%" /var/lib/jenkins/jobs/tmp_config.xml

# PROJECT_NAME=VU_Bird_Flight; SVN_PROJECT=BirdFI; sed -i 's%${svnproject}%'"$SVN_PROJECT%" /var/lib/jenkins/jobs/tmp_config.xml
sed -i 's%${svnproject}%'"$SVN_PROJECT%" /var/lib/jenkins/jobs/tmp_config.xml

# PROJECT_NAME=VU_Bird_Flight; DJANGO_APP=BirdFI; sed -i 's%${djangoapp}%'"$DJANGO_APP%" /var/lib/jenkins/jobs/tmp_config.xml
sed -i 's%${djangoapp}%'"$DJANGO_APP%" /var/lib/jenkins/jobs/tmp_config.xml

####### Create project using configuration file.
echo "Where am I."
pwd

cd /var/lib/jenkins

# Login properly as jenkins_admin for subsequent script execution.
# JENKINS_ADMIN_PASSWORD=monkeyblood#7t; java -jar jenkins-cli.jar -s http://localhost:8080/ login --username jenkins_admin --password $JENKINS_ADMIN_PASSWORD
java -jar jenkins-cli.jar -s http://localhost:8080/ login --username jenkins_admin --password $JENKINS_ADMIN_PASSWORD

# PROJECT_NAME=VU_Bird_Flight; java -jar jenkins-cli.jar -s http://localhost:8080/ create-job $PROJECT_NAME < /var/lib/jenkins/jobs/tmp_config.xml
java -jar jenkins-cli.jar -s http://localhost:8080/ create-job $PROJECT_NAME < /var/lib/jenkins/jobs/tmp_config.xml

####### Configure Subversion authentication man wget for project.

export SVN_SCRIPT="
def url = '$SVN_REPO_URL' \n
def username = '$SVN_USERNAME' \n
def password = '$SVN_PASSWORD' \n
def jenkins = hudson.model.Hudson.instance \n
def job = jenkins.getItem('$PROJECT_NAME') \n
def upc = new hudson.scm.UserProvidedCredential(username, password, null, job) \n     
def log = new StringWriter()  \n
def logWriter = new PrintWriter(log)  \n
new hudson.scm.SubversionSCM.DescriptorImpl().postCredential(url, upc, logWriter)  \n
"
echo -e $SVN_SCRIPT | java -jar jenkins-cli.jar -s http://localhost:8080/ groovy = 

# Logout jenkins_admin.
# java -jar jenkins-cli.jar -s http://localhost:8080/ logout
java -jar jenkins-cli.jar -s http://localhost:8080/ logout

