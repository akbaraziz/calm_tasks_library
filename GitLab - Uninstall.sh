#!/bin/bash
##############################################
# Name        : Gitlab_uninstallation.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script to remove gitlab
# Compatibility : Centos 6, 7
##############################################

set -ex

sudo yum remove -y gitlab*
