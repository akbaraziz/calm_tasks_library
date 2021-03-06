#!/bin/bash

set -ex

echo "@@{user_creds}@@" | sudo -S ls

echo "** Installing python-pip..."
sudo apt-get -y install python-pip

echo "** Upgrade pip..."
sudo pip install --upgrade pip

echo "** Install docker-compose..."
sudo pip install docker-compose