#!/bin/bash

set -ex

HOST_NAME=@@{HOST_NAME}@@
IPADDR=@@{address}@@
sudo hostnamectl set-hostname ${HOST_NAME}

sudo echo ${HOST_NAME} | tee /etc/hostname
sudo sed -i -E 's/^127.0.1.1.*/127.0.1.1\t'"${HOST_NAME}"'/' /etc/hosts
sudo sed -i -E 's/^127.0.1.1.*/127.0.1.1\t'"${HOST_NAME}"'/' /etc/sysconfig/network
sudo echo -e ""${IPADDR}" \t "${HOST_NAME}"" >> /etc/hosts

sudo systemctl restart network