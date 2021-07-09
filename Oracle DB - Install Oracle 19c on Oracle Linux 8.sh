#!/bin/bash

set -ex

export DOWNLOAD_URL=apache-1.lab.local

export TMP=/tmp

export ORACLE_HOSTNAME="@@{HOST_NAME}@@"
export ORACLE_UNQNAME="@@{ORACLE_UNQ}@@"
export ORACLE_BASE="@@{ORACLE_BASE}@@"
export ORACLE_HOME="@@{ORACLE_BASE}@@"/product/"@@{ORACLE_VERSION}@@"/dbhome_1
export ORA_INVENTORY="@@{ORA_INVENTORY}@@"
export ORACLE_SID="@@{ORACLE_SID}@@"
export PDB_NAME="@@{PDB_NAME}@@"
export DATA_DIR="@@{DATA_DIR}@@"


#export PATH=/usr/sbin:/usr/bin:/usr/local/bin:\$PATH
export PATH=$PATH:$ORACLE_HOME/bin

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;

# Download Oracle 19 Software
wget -O /home/oracle/oracle19c.zip http://$DOWNLOAD_URL/oracle/LINUX.X64_193000_db_home.zip

# Unzip Software
sudo unzip -q /home/oracle/oracle19c.zip -d $ORACLE_HOME

sudo cat <<EOF | sudo tee $ORACLE_HOME//cv/admin/cvu_config
# Configuration file for Cluster Verification Utility(CVU)
# Version: 011405
#
# NOTE:
# 1._ Any line without a '=' will be ignored
# 2._ Since the fallback option will look into the environment variables,
#     please have a component prefix(CV_) for each property to define a
#     namespace.
#


#Nodes for the cluster. If CRS home is not installed, this list will be
#picked up when -n all is mentioned in the commandline argument.
#CV_NODE_ALL=

#if enabled, cvuqdisk rpm is required on all nodes
CV_RAW_CHECK_ENABLED=TRUE

# Fallback to this distribution id
CV_ASSUME_DISTID=OEL8

#Complete file system path of sudo binary file, default is /usr/local/bin/sudo
CV_SUDO_BINARY_LOCATION=/usr/local/bin/sudo

#Complete file system path of pbrun binary file, default is /usr/local/bin/pbrun
CV_PBRUN_BINARY_LOCATION=/usr/local/bin/pbrun

# Whether X-Windows check should be performed for user equivalence with SSH
#CV_XCHK_FOR_SSH_ENABLED=TRUE

# To override SSH location
#ORACLE_SRVM_REMOTESHELL=/usr/bin/ssh

# To override SCP location
#ORACLE_SRVM_REMOTECOPY=/usr/bin/scp

# To override version used by command line parser
CV_ASSUME_CL_VERSION=19.1.0.0.0

# Location of the browser to be used to display HTML report
#CV_DEFAULT_BROWSER_LOCATION=/usr/bin/mozilla

# Maximum number of retries for discover DHCP server
#CV_MAX_RETRIES_DHCP_DISCOVERY=5

# Maximum CVU trace files size (in multiples of 100 MB)
#CV_TRACE_SIZE_MULTIPLIER=1
EOF

# Install Oracle
sudo chown -R oracle:oinstall $ORACLE_HOME

sudo -u oracle /u01/app/oracle/product/19.3.0.0/dbhome_1/runInstaller -ignorePrereq -waitforcompletion -silent \
-responseFile /u01/app/oracle/product/19.3.0.0/dbhome_1/install/response/db_install.rsp \
oracle.install.option=INSTALL_DB_SWONLY                                    	\
ORACLE_HOSTNAME=@@{HOST_NAME}@@                                       		\
UNIX_GROUP_NAME=oinstall                                                   	\
INVENTORY_LOCATION=$ORA_INVENTORY                                    		\
SELECTED_LANGUAGES=en,en_US                                                	\
ORACLE_HOME=$ORACLE_HOME                      								\
ORACLE_BASE=$ORACLE_BASE                                           			\
oracle.install.db.InstallEdition=EE                      	                \
oracle.install.db.OSDBA_GROUP=dba											\
oracle.install.db.OSOPER_GROUP=oper											\
oracle.install.db.OSBACKUPDBA_GROUP=backupdba                               \
oracle.install.db.OSDGDBA_GROUP=dgdba                                       \
oracle.install.db.OSKMDBA_GROUP=kmdba                                       \
oracle.install.db.OSRACDBA_GROUP=racdba                                     \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 	\
DECLINE_SECURITY_UPDATES=true

# Execute as Root
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/"@@{ORACLE_VERSION}@@"/dbhome_1/root.sh