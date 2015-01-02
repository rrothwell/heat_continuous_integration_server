#!/bin/bash

# Deployment directory for Jenkin's use.
# virtualenv is located here.
#mkdir -p /usr/local/django/$PROJECT_NAME_virtenv
#chown jenkins /usr/local/django/$PROJECT_NAME_virtenv

# For a local SVN Server create a repository at 
# /usr/local/svn/repos/BirdFI/

# Then populate the local SVN repo on the CI server using this command:
# svnrdump load  --username jbloggs  svn://130.56.248.66/BirdFI <  bird_fi_dump

# To provide credentials for svnrdump add to the workstation ~/.ssh/config a line like:
#Host 130.56.248.66
#        IdentityFile ~/.ssh/richard_on_nectar_v3.pem

# Otherwise target the official project repo.

virtualenv $WORKSPACE
source $WORKSPACE/bin/activate
pip install -r $WORKSPACE/webapp/BirdFI/REQUIREMENTS.txt           
python $WORKSPACE/webapp/BirdFI/manage.py migrate 
#pushd $WORKSPACE/webapp/BirdFI/BirdFI/
#python $WORKSPACE/webapp/BirdFI/manage.py compilemessages
#popd
#python $WORKSPACE/webapp/BirdFI/manage.py collectstatic --noinput
#sudo apachectl graceful
daemon --name=django_server python $WORKSPACE/webapp/BirdFI/manage.py runserver 0.0.0.0:8000
python $WORKSPACE/webapp/BirdFI/manage.py test --noinput
