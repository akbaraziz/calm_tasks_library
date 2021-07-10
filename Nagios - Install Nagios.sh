#!/bin/bash
##############################################
# Name        : Nagios_setup.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script to setup nagios and plugins
# Compatibility : Centos 6, 7
##############################################

set -ex

sudo yum update -y --quiet
sudo yum install -y epel-release

sudo hostnamectl set-hostname --static @@{name}@@

sudo yum install -y nagios nagios-plugins-all nagios-plugins-nrpe
