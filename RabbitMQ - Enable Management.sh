#!/bin/bash
##############################################
# Name        : RabbitMQ_management_enable.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script to enable management server
# Compatibility : Centos 6, 7
##############################################

set -ex

sudo rabbitmq-plugins enable rabbitmq_management
sudo systemctl restart rabbitmq-server
