#!/bin/bash
##############################################
# Name        : Docker_Bootstrap.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script is used to install docker engine
# Compatibility : Centos 6, 7
##############################################

set -ex

sudo yum update -y --quiet

#Install NTP
sudo yum install -y ntp
sudo ntpdate pool.ntp.org

#Remove any Old docker version
sudo yum remove -y docker docker-common container-selinux docker-selinux docker-engine

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce

sudo sed -i '/ExecStart=/c\\ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock' /usr/lib/systemd/system/docker.service
sudo systemctl enable docker
sudo usermod -a -G docker $USER
sudo systemctl start docker
