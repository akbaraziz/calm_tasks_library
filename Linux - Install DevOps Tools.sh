#!/bin/bash

set -ex

# Variables Used
USER="@@{LinuxUser.username}@@"
PASSWORD="@@{LinuxUser.secret}@@"

# Add new User
echo "@@{user_creds}@@" | sudo -S ls
sudo useradd $USER -m -d /home/$USER -p $PASSWORD
sudo usermod -G sudo $USER

echo "AllowUsers root $USER @@{LinuxAdmin.username}@@" | sudo tee -a /etc/ssh/sshd_config
echo "$USER		 ALL=(ALL:ALL)	ALL" | sudo tee -a /etc/sudoers
echo "@@{LinuxAdmin.username}@@		ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

# Create User SSH Key
#sudo mkdir -p /home/${USER}/.ssh \
#&& sudo ssh-keygen -f /home/${USER}/.ssh/mykey -N '' \
#&& sudo chown -R ${USER}:${USER} /home/${USER}/.ssh

# Install Docker
sudo apt-get -y -qq install docker.io 

# Install Ansible
sudo apt-get -y -qq install ansible 

# Install Java OpenJDK
sudo apt-get -y -qq install openjdk-8-jdk

# Install Required Packages
sudo apt-get -y -qq install unzip python3-pip wget apt-transport-https ca-certificates curl gnupg software-properties-common git zsh

# Install PIP and Update
sudo pip3 install -qq --upgrade pip

# Add Docker Permissions
sudo usermod -G docker ${USER}
sudo mkdir -p /home/${USER}/.cache
sudo chown -R ${USER}:${USER} /home/${USER}/.cache

# Install AWS CLI Tools
export PATH=$PATH:/home/${USER}/.local/bin
sudo pip3 install -U -qq botocore && sudo pip3 install -qq botocore --upgrade --user 
sudo pip3 install -U -qq awscli && sudo pip3 install -qq awscli --upgrade --user

# Install Azure CLI Tools
sudo pip3 install -U -qq azure-cli && sudo pip3 install -qq azure-cli --upgrade --user

# Install NodeJS abd NPM
sudo apt-get -y -qq install nodejs npm

# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get -y -qq install terraform

# Install Packer
sudo apt-get -y -qq install packer

# Install Vagrant
sudo apt-get -y -qq install vagrant

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Go 
sudo wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz

echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc

export PATH=$PATH:/usr/local/go/bin

# Install VSCode
#sudo wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
#sudo apt-get install -f ./code_1.59.0-1628120042_amd64.deb
sudo snap install --classic code 

# Install Oh-My-ZSH
# Install OhMyZSH
git clone https://github.com/jotyGill/quickz-sh.git
cd quickz-sh
sudo ./quickz.sh -c

sudo usermod --shell /bin/zsh @@{LinuxAdmin.username}@@