#!/bin/bash
set -ex

#Install epel release and java
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk.x86_64