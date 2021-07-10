#!/bin/bash

set -ex

sudo subscription-manager register --username=@@{RhnAdmin.username}@@ --password=@@{RhnAdmin.secret}@@ --auto-attach

# Disable Redhat Original Repo
sudo mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.orig

sudo yum clean all