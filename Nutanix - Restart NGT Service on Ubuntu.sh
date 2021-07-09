#!/bin/bash

set -ex

echo "@@{user_creds}@@" | sudo -S ls
sudo systemctl restart ngt_guest_agent