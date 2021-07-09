#!/bin/bash

ls /etc/redhat-release

if [ $? -eq 0]
then
    echo "CentOS VM"
    exit 0
else
    echo "Ubuntu VM"
    exit 1
fi