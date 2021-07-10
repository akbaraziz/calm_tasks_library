#!/bin/bash

set -ex

# Disable selinux
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g;s/SELINUXTYPE=targeted/#&/g' /etc/selinux/config

echo '!includedir /etc/my.cnf.d' | sudo tee /etc/my.cnf

echo '[mysqld]
binlog-format=mixed
log-bin=mysql-bin
datadir=/mysql/data
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
innodb_data_home_dir = /mysql/data
innodb_log_group_home_dir = /mysql/log
innodb_file_per_table
tmpdir=/mysql/tmpdir
innodb_undo_directory = /mysql/undo

default_tmp_storage_engine = innodb
innodb_log_files_in_group = 4
innodb_log_file_size = 1G
innodb_log_buffer_size = 8M
innodb_buffer_pool_size = 6G
large-pages
innodb_buffer_pool_instances = 64
innodb_flush_method=O_DIRECT
innodb_flush_neighbors=0
innodb_flush_log_at_trx_commit=1
innodb_buffer_pool_dump_at_shutdown=1
innodb_buffer_pool_load_at_startup=1
bulk_insert_buffer_size = 256
innodb_thread_concurrency = 16

# Undo tablespace
innodb_undo_tablespaces = 5

# Networking
wait_timeout=57600
max_allowed_packet=1G
socket=/var/lib/mysql/mysql.sock
skip-name-resolve
port=3306
max_connections=1000' | sudo tee /etc/my.cnf.d/nutanix.cnf

sudo sed -i "/\[mysqld\]/a server-id=100" /etc/my.cnf.d/nutanix.cnf

# -*- Sysctl configuration
mysql_grp_id=`id -g mysql`
sudo sysctl -w vm.swappiness=0
sudo sysctl -w vm.nr_hugepages=1024
sudo sysctl -w vm.overcommit_memory=1
sudo sysctl -w vm.dirty_background_ratio=5
sudo sysctl -w vm.dirty_ratio=15
sudo sysctl -w vm.dirty_expire_centisecs=500
sudo sysctl -w vm.dirty_writeback_centisecs=100
sudo sysctl -w vm.hugetlb_shm_group=$mysql_grp_id

echo 'vm.swappiness=0
vm.nr_hugepages=1024
vm.overcommit_memory=1
vm.dirty_background_ratio=5
vm.dirty_ratio=15
vm.dirty_expire_centisecs=500
vm.dirty_writeback_centisecs=100
vm.hugetlb_shm_group=$mysql_grp_id' | sudo tee  -a /etc/sysctl.conf

echo "ACTION=='add|change', SUBSYSTEM=='block', RUN+='/bin/sh -c \"/bin/echo 1024 > /sys%p/queue/max_sectors_kb\"'" | sudo tee /etc/udev/rules.d/71-block-max-sectors.rules
#echo 1024 | sudo tee /sys/block/sd?/queue/max_sectors_kb

echo "/dev/mariadbDataVG/mariadbDataLV /mysql/data ext4 rw,noatime,nobarrier,stripe=4096,data=ordered 0 0" | sudo tee -a /etc/fstab
echo "/dev/mariadbLogVG/mariadbLogLV /mysql/log ext4 rw,noatime,nobarrier,stripe=4096,data=ordered 0 0" | sudo tee -a /etc/fstab
sudo mkdir -p /mysql/log /mysql/data /mysql/tmpdir /mysql/undo
sudo mount -a

sudo rm -rf /mysql/data/*
sudo mysql_install_db &>/dev/null
sudo chown -R mysql:mysql /mysql

sudo systemctl enable mariadb
sudo systemctl start mariadb

# Set root password
sudo mysqladmin password '@@{MARIADB_PASSWORD}@@'