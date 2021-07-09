#!/bin/bash

set -ex

echo "@@{user_creds}@@" | sudo -S ls
sudo hostnamectl set-hostname @@{HOST_NAME}@@