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

# Deployment directory for Jenkin's use.
# virtualenv is located here.
#mkdir -p /usr/local/django/$PROJECT_NAME_virtenv
#chown jenkins /usr/local/django/$PROJECT_NAME_virtenv

##!/bin/bash
#virtualenv $WORKSPACE
#source $WORKSPACE/bin/activate
#pip install -r $WORKSPACE/webapp/BirdFI/REQUIREMENTS.txt           
#python $WORKSPACE/webapp/BirdFI/manage.py migrate 
##pushd $WORKSPACE/webapp/BirdFI/BirdFI/
##python $WORKSPACE/webapp/BirdFI/manage.py compilemessages
##popd
##python $WORKSPACE/webapp/BirdFI/manage.py collectstatic --noinput
##sudo apachectl graceful
#daemon --name=django_server python $WORKSPACE/webapp/BirdFI/manage.py runserver 0.0.0.0:8000
#python $WORKSPACE/webapp/BirdFI/manage.py test --noinput

# For a local SVN Server create a repository at 
# /usr/local/svn/repos/BirdFI/

# Add creditials to ~/.ssh/config like:
#Host 130.56.248.66
#        IdentityFile ~/.ssh/richard_on_nectar_v3.pem

# Then populate the local SVN repo on the CI server using this command:
# svnrdump load  --username jbloggs  svn://130.56.248.66/BirdFI <  bird_fi_dump

# Otherwise target the official project repo.
