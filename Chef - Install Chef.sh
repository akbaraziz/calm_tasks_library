#!/bin/bash
##############################################
# Name        : Chef_Bootstrap.sh
# Author      : Calm Devops
# Version     : 1.1
# Description : Script is used to bootstrap chef nodes
# Compatibility : Centos 7 and 8
##############################################

set -ex

sudo yum update -y --quiet

CHEF_VERSION="@@{CHEF_VERSION}@@"

#CentOS 7
wget https://packages.chef.io/files/stable/chef-server/$CHEF_VERSION/el/7/chef-server-core-$CHEF_VERSION-1.el7.x86_64.rpm

#CentOS 8
#wget https://packages.chef.io/files/stable/chef-server/$CHEF_VERSION/el/8/chef-server-core-$CHEF_VERSION-1.el7.x86_64.rpm

# Install Chef Server - CentOS 7
sudo rpm -Uvh chef-server-core-$CHEF_VERSION-1.el7.x86_64.rpm

# Install Chef Server - CentOS 8
#sudo rpm -Uvh chef-server-core-$CHEF_VERSION-1.el7.x86_64.rpm
