#!/bin/bash
set -ex

##############################################
# Name        : Chef_Bootstrap.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script is used to bootstrap chef nodes
# Compatibility : Centos 6, 7
##############################################

sudo yum update -y --quiet

wget https://packages.chef.io/files/stable/chef-server/14.0.65/el/7/chef-server-core-14.0.65-1.el7.x86_64.rpm
# curl -L https://www.chef.io/chef/install.sh | sudo bash
