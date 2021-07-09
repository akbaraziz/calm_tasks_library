#!/bin/bash

set -ex

echo "@@{user_creds}@@" | sudo -S ls
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt install ansible -y