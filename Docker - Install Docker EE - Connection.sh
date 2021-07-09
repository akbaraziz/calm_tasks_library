#!/bin/bash
set -ex

sudo hostnamectl set-hostname --static docker-registry
sudo mkdir -p /opt/docker

# Remove any Old docker version
sudo yum remove docker docker-common container-selinux docker-selinux docker-engine


# Install Docker Pre-Reqs
sudo yum install -y --quiet yum-utils device-mapper-persistent-data lvm2 container-selinux ntp yum-config-manager

# Create Docker Repo
export DOCKERURL="https://storebits.docker.com/ee/m/sub-ae014e74-06b4-40c6-abe6-bc0529daedd3"
sudo yum-config-manager --add-repo $DOCKERURL/rhel/docker-ee.repo
sudo -E sh -c 'echo "$DOCKERURL/rhel" > /etc/yum/vars/dockerurl'
sudo -E sh -c 'echo "7" > /etc/yum/vars/dockerosversion'

# Create Docker Volumes
sudo pvcreate /dev/sd{b,c,d}
sudo vgcreate docker /dev/sd{b,c,d}
sleep 3
sudo lvcreate -l 100%VG -n docker_lvm docker
sudo mkfs.xfs /dev/docker/docker_lvm

# Install Docker EE
sudo yum install -y --quiet docker-ee docker-selinux docker-ee-cli
sudo sed -i '/ExecStart=/c\\ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock' /usr/lib/systemd/system/docker.service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker $USER

# Mount Docker Volumes
sudo echo -e "/dev/docker/docker_lvm \t /opt/docker \t xfs \t defaults \t 0 0" | sudo tee -a /etc/fstab
sudo mount -a

shutdown -r

sleep 30