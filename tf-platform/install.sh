#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Updating the base packages
sudo yum update -y
sudo yum install wget -y 
sudo yum install zip -y
sudo yum install git -y
sudo yum install tar -y

#Installing java
sudo yum install java-1.8.0-openjdk-devel -y

#Getting jenkins-repo
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y

#Starting Jenkins as a service
sudo systemctl start jenkins

#Enabling at boot
sudo systemctl enable jenkins


#Installing aws-cli
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

#Installing docker
sudo yum install docker -y 
sudo systemctl start podman
sudo systemctl enable podman

#Installing kubectl
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

#Epel repo
sudo amazon-linux-extras install epel -y