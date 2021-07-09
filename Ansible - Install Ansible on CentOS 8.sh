#!/bin/bash

set -ex

sudo dnf install python3 wget unzip tar ansible -y --quiet

sudo systemctl enable --now ansible