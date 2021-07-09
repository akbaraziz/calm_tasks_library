#!/bin/bash

set -ex

sudo ifconfig eth0 @@{IP_ADDRESS}@@ netmask @@{SUBNET_MASK}@@
sudo route add default gw @@{GATEWAY}@@
sudo systemctl restart network

sleep 10