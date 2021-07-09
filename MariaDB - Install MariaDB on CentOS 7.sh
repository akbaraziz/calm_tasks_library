#!/bin/bash

set -ex

# Create MariaDB Repo
 cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# Clear Yum Cache
sudo yum makecache fast

# Install MariaDB
sudo yum -y install MariaDB-server MariaDB-client

# Start and Enable MariaDB Service
sudo systemctl enable --now mariadb