#!/bin/bash

set -ex

# Download and Install Oracle Pre-Req RPM
sudo dnf install -y oracle-database-preinstall-19c

# Disable Firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Create Volumes
if [ -e /dev/sdd ];
then
    sudo pvcreate /dev/sd{b,c}
    sudo vgcreate u01 /dev/sdb
    sudo vgcreate u02 /dev/sdc
fi
sleep 5

if [ -e /dev/sdd ];
then
    sudo lvcreate -l 100%VG -n u01_lvm u01
    sudo lvcreate -l 100%VG -n u02_lvm u02
    sudo mkfs.xfs /dev/u01/u01_lvm
    sudo mkfs.xfs /dev/u02/u02_lvm
    echo -e "/dev/u01/u01_lvm \t /u01 \t xfs \t defaults \t 0 0" | sudo tee -a /etc/fstab
    echo -e "/dev/u02/u02_lvm \t /u02 \t xfs \t defaults \t 0 0" | sudo tee -a /etc/fstab
fi

# Create Directories
sudo mkdir -p /home/oracle/scripts
sudo mkdir -p /u01/app/oracle/product/19.3.0/dbhome_1
sudo mkdir -p /u01/app/oraInventory
sudo mkdir -p /u02/oradata

chown -R oracle:oinstall /u01 /u02
chmod -R 775 /u01 /u02

# Create Environment Configuration
sudo -u oracle cat > /home/oracle/scripts/setEnv.sh <<EOF
# Oracle Settings
export TMP=/tmp
export TMPDIR=\$TMP

export ORACLE_HOSTNAME=@@{HOSTNAME}@@
export ORACLE_UNQNAME=@@{ORACLE_UNQ}@@
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19.3.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_SID=@@{ORACLE_SID}@@
export PDB_NAME=@@{PDB_NAME}@@
export DATA_DIR=/u02/oradata

export PATH=/usr/sbin:/usr/local/bin:\$PATH
export PATH=\$ORACLE_HOME/bin:\$PATH

export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias tns='cd $ORACLE_HOME/network/admin'
alias envo='env | grep ORACLE'

umask 022

if [ $USER = "oracle" ]; then
    if [ $SHELL = "/bin/ksh" ]; then
       ulimit -u 16384
       ulimit -n 65536
    else
       ulimit -u 16384 -n 65536
    fi
fi

envo
EOF

# Update Profile
sudo -u oracle echo ". /home/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile

# Create Start All Script
sudo -u oracle cat > /home/oracle/scripts/start_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbstart \$ORACLE_HOME
EOF

# Create Stop All Script
sudo -u oracle cat > /home/oracle/scripts/stop_all.sh <<EOF
#!/bin/bash
. /home/oracle/scripts/setEnv.sh

export ORAENV_ASK=NO
. oraenv
export ORAENV_ASK=YES

dbshut \$ORACLE_HOME
EOF

sudo chown -R oracle:oinstall /home/oracle/scripts
sudo chmod u+x /home/oracle/scripts/*.sh

# Create Oracle Service
cat > /lib/systemd/system/dbora.service <<EOF
[Unit]
Description=The Oracle Database Service
After=syslog.target network.target

[Service]
# systemd ignores PAM limits, so set any necessary limits in the service.
# Not really a bug, but a feature.
# https://bugzilla.redhat.com/show_bug.cgi?id=754285
LimitMEMLOCK=infinity
LimitNOFILE=65535

#Type=simple
# idle: similar to simple, the actual execution of the service binary is delayed
#       until all jobs are finished, which avoids mixing the status output with shell output of services.
RemainAfterExit=yes
User=oracle
Group=oinstall
Restart=no
ExecStart=/bin/bash -c '/home/oracle/scripts/start_all.sh'
ExecStop=/bin/bash -c '/home/oracle/scripts/stop_all.sh'

[Install]
WantedBy=multi-user.target
EOF

# System Reload
sudo systemctl daemon-reload