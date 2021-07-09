#!/bin/bash
set -ex

#Import jenkins-ci rpm and install jenkins
sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
sudo curl -o /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo yum install -y jenkins

# Enable and Start Jenkins Services
sudo chkconfig jenkins on
sudo systemctl start jenkins

# Set a Shell for Jenkins User
sudo usermod -s /bin/bash jenkins

# Add Jenkins user to sudoers file
echo "jenkins      ALL=(ALL) NOPASSWD" | sudo tee -a /etc/sudoers > /dev/null

# Add Firewall Rules if Running
if [ `systemctl is-active firewalld` ]
then
    firewall-cmd --permanent --service=jenkins --set-short="Jenkins Service Ports"
    firewall-cmd --permanent --service=jenkins --set-description="Jenkins service firewalld port exceptions"
    firewall-cmd --permanent --add-service=jenkins
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --reload
else
    firewall_status=inactive
fi

# Get auth password from Jenkins
echo "authpwd="$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)