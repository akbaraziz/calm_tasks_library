#!/bin/bash

set -ex

# Register with Satellite
sudo subscription-manager register --username=@@{SATELLITE.username}@@ --password=@@{SATELLITE.secret}@@ --org=Connection_Inc --environment=Library --auto-attach --force

# Register DataDog Repo
sudo subscription-manager attach --pool=2c9404bd70888be80170a13727d0081e

# Clear yum cache
sudo yum clean all