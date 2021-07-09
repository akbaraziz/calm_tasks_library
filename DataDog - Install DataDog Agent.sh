#!/bin/bash

set -ex

KEY=930eeda0e850f833c513d66235a6e6f1

# Install DataDog Agent
sudo yum install --nogpgcheck -y datadog-agent

# Update DataDog API Key
sudo sh -c "sed 's/api_key:.*/api_key: $KEY/' /etc/datadog-agent/datadog.yaml.example > /etc/datadog-agent/datadog.yaml"

# Start DataDog Agent
sudo service datadog-agent start