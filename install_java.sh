#!/bin/bash
# ===========================================
# Copyright NeCTAR, May 2014, all rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions 
# and limitations under the License.
# ===========================================
# install_java.sh
# ===========================================
# Install Java on ALL machines.
# Oracle Java version 7

# Ensure JAVA_HOME and PATH are setup?
# ===========================================

#Register repo
add-apt-repository ppa:webupd8team/java
apt-get -q -y update 

# Bypass Oracle license dialog.
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# Install.
apt-get -y install java-common  oracle-java7-installer  oracle-java7-set-default

# Register alternatives. Maybe some redundancy here that can be removed later.
update-java-alternatives -s java-7-oracle

# Set the JAVA environment variables.
echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment;
export JAVA_HOME=/usr/lib/jvm/java-7-oracle/
