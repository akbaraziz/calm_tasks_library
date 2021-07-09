#!/bin/bash

set -ex

# Download Oracle 19 Software
wget http://apache-1.lab.local/oracle/LINUX.X64_193000_db_home.zip -o /var/tmp/LINUX.X64_193000_db_home.zip

# Unzip Software
cd $ORACLE_HOME
sudo -u oracle unzip -oq /var/tmp/LINUX.X64_193000_db_home.zip

# Set OS Version
sudo -u oracle export CV_ASSUME_DISTID=OEL8.3

# Install Oracle
sudo -u oracle ./runInstaller -ignorePrereq -waitforcompletion -silent                        \
-responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
oracle.install.option=INSTALL_DB_SWONLY                                    \
ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                                         \
UNIX_GROUP_NAME=oinstall                                                   \
INVENTORY_LOCATION=${ORA_INVENTORY}                                        \
SELECTED_LANGUAGES=en,en_GB                                                \
ORACLE_HOME=${ORACLE_HOME}                                                 \
ORACLE_BASE=${ORACLE_BASE}                                                 \
oracle.install.db.InstallEdition=EE                                        \
oracle.install.db.OSDBA_GROUP=dba                                          \
oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
oracle.install.db.OSDGDBA_GROUP=dba                                        \
oracle.install.db.OSKMDBA_GROUP=dba                                        \
oracle.install.db.OSRACDBA_GROUP=dba                                       \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
DECLINE_SECURITY_UPDATES=true

# Execute as Root
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/19.3.0/dbhome_1/root.sh