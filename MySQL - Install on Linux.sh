#!/bin/bash
set -ex

sudo yum update -y
mysql_repo_package="http://repo.mysql.com/mysql-community-release-el7.rpm"
sudo yum install -y $mysql_repo_package
sudo yum update -y
sudo yum install -y sshpass mysql-community-server.x86_64

sudo systemctl start mysqld
sudo service mysqld status

echo "Retrieving MySQL Temporary Password"

tmpPasswd="$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $13}')"
#sudo export tmpPasswd
sudo echo "Temp SQL password:"$tmpPasswd
#"mysql_password=$tmpPasswd"

echo "Logging into MySQL database"

sudo yum install -y expect

MYSQL_UPDATE=$(expect -c "
set timeout 5
spawn mysql -u root -p
expect \"Enter password: \"
send \"${tmpPasswd}\r\"
expect \"mysql>\"
send \"ALTER USER 'root'@'localhost' IDENTIFIED BY 'Nutanix/4u';\r\"
expect \"mysql>\"
send \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');\r\"
expect \"mysql>\"
send \"DELETE FROM mysql.user WHERE User='';\r\"
expect \"mysql>\"
send \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';\r\"
expect \"mysql>\"
send \"flush privileges;\r\"
expect \"mysql>\"
send \"quit;\r\"
expect eof
")

echo "$MYSQL_UPDATE"

sudo yum remove -y expect
#Mysql secure installation
#sudo mysql -u root<<-EOF
#UPDATE mysql.user SET Password=PASSWORD('@@{MYSQL_PASSWORD}@@') WHERE User='root';
#DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
#DELETE FROM mysql.user WHERE User='';
#DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
#FLUSH PRIVILEGES;
#EOF

### Configure mysql
sudo sed -i '/\[mysqld\]/a log-bin=mysql-bin' /etc/my.cnf
sudo sed -i "/\[mysqld\]/a server-id=100" /etc/my.cnf
sudo sed -i "/\[mysqld\]/a binlog-format=mixed" /etc/my.cnf
echo "#master=100" | sudo tee -a  /etc/my.cnf

server_id=`sudo cat /etc/my.cnf | grep  "server-id=" | cut -d= -f2`
is_master=`sudo cat /etc/my.cnf | grep -q -w "#master=$server_id"; echo $?`

if [ ${is_master} -ne 0 ]
then
    sudo sed -i '/\[mysqld\]/a read_only=1' /etc/my.cnf
fi

sudo systemctl restart mysqld
sleep 2
