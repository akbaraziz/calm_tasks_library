#!/bin/bash
set -ex

#Download script to install plugins
sudo yum -y install unzip
sudo curl -o batch-install-jenkins-plugins.sh https://gist.githubusercontent.com/micw/e80d739c6099078ce0f3/raw/33a21226b9938382c1a6aa68bc71105a774b374b/install_jenkins_plugin.sh
sudo chmod +x batch-install-jenkins-plugins.sh

#Copy required plugins
echo 'credentials-binding
windows-slaves
ssh-credentials
ssh-slaves
credentials
plain-credentials
credentials-binding
authentication-tokens
nutanix-calm
pam-auth
script-security
cloudbees-folder
cloudbees-credentials' | sudo tee plugins


#Install plugins
sudo systemctl stop jenkins
sudo mkdir -p /var/lib/jenkins/plugins
sudo ./batch-install-jenkins-plugins.sh $(echo $(cat plugins))
sudo systemctl start jenkins
sleep 60