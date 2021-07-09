#!/bin/bash

##############
#
# LVM setup script for MariaDB . 4 disks for DATA and 4 for logs
# Data disks are 50GB | Log disks are 25GB
#
#############
sudo yum -y update
sudo yum -y install lvm2 iotop

#MariaDB data
sudo pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde
sudo vgcreate mariadbDataVG /dev/sdb /dev/sdd /dev/sdc /dev/sde
sudo lvcreate -l 100%FREE -i4 -I1M -n mariadbDataLV mariadbDataVG          ## Use 1MB to avoid IO amplification
#lvcreate -l 100%FREE -i4 -I4M -n pgDataLV pgDataVG


#MariaDB logs
sudo pvcreate /dev/sdf /dev/sdg /dev/sdh /dev/sdi
sudo vgcreate mariadbLogVG /dev/sdf /dev/sdg /dev/sdh /dev/sdi
sudo lvcreate -l 100%FREE -i2 -I1M -n mariadbLogLV mariadbLogVG            ## Use 1MB to avoid IO amplification
#lvcreate -l 100%FREE -i2 -I4M -n pgLogLV pgLogVG


#Disable LVM read ahead
sudo lvchange -r 0 /dev/mariadbDataVG/mariadbDataLV
sudo lvchange -r 0 /dev/mariadbLogVG/mariadbLogLV


#Format LVMs with ext4 and use nodiscard to make sure format time is fast on Nutanix due to SCSI unmap
sudo mkfs.ext4 -E nodiscard /dev/mariadbDataVG/mariadbDataLV
sudo mkfs.ext4 -E nodiscard /dev/mariadbLogVG/mariadbLogLV

sleep 30