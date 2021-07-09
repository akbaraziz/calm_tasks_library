#!/bin/bash

set -ex

# Add user
useradd -G wheel @@{USER_NAME}@@

echo "Please Enter a Password for your new username"
echo @@{USER_PASSWORD}@@ | passwd --stdin "@@{USER_NAME}@@"