#!/bin/bash

set -ex

KEY=?

# Install DataDog Agent
sudo yum install --nogpgcheck -y datadog-agent

# Update DataDog API Key
sudo sh -c "sed 's/api_key:.*/api_key: $KEY/' /etc/datadog-agent/datadog.yaml.example > /etc/datadog-agent/datadog.yaml"

# Start DataDog Agent
sudo service datadog-agent start