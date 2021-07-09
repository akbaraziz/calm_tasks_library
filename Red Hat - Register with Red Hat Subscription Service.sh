#!/bin/bash

set -ex

sudo subscription-manager register --username=@@{RHN_CRED.username}@@ --password=@@{RHN_CRED.secret}@@ --auto-attach

# Disable Redhat Original Repo
sudo mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.orig

sudo yum clean all