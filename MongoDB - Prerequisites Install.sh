#!/bin/bash

set -ex

## -*- Install Pre-requisites for Mongodb
sudo yum update -y --quiet
sudo yum install -y  wget xfs* bc unzip lvm2* lsscsi numactl

#Disable SELINUX
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "System packages are installed"