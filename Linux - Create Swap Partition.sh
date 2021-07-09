#!/bin/bash

set -ex

# Create Swap Partition
sudo dd if=/dev/zero of=swapfile bs=1MiB count=$((4*2014))
sudo chmod 600 swapfile
sudo mkswap swapfile
sudo swapon swapfile