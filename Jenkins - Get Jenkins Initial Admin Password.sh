#!/bin/bash

#Get auth password from jenkins master
echo "authpwd="$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)