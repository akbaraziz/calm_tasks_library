#!/bin/bash
##############################################
# Name        : RabbitMQ_Start.sh
# Author      : Calm Devops
# Version     : 1.0
# Description : Script to start RabbitMQ 
# Compatibility : Centos 6, 7
##############################################

set -ex

sudo systemctl enable --now rabbitmq-server