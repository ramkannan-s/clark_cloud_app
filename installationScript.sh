#! /bin/bash

##### Basic Packages Installations
yum update -y
yum install epel-release yum-utils -y
yum install git ansible wget vim zip unzip ruby rubygems dejavu-sans-fonts fontconfig xorg-x11-server-Xvfb -y

##### Python and boto3
yum install python3-pip -y
yum install python-boto3 -y
yum install python-botocore -y
pip3 install boto3
ansible-galaxy collection install amazon.aws

##### GitCrypt
wget https://cbs.centos.org/kojifiles/packages/git-crypt/0.5.0/1.el7/x86_64/git-crypt-0.5.0-1.el7.x86_64.rpm
rpm -ivh git-crypt-0.5.0–1.el7.x86_64.rpm
git-crypt version

##### Jenkins Installation - Port 8083
yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel -y
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins -y
sed -i -e "s/8080/8083/g" /etc/sysconfig/jenkins 
usermod -aG wheel jenkins
service jenkins start

##### Clone Repo and Jenkins Plugin Installations 
git clone https://github.com/ramkannan-s/clark_cloud_app.git
cd clark_cloud_app/
./jenkins_plugin_install.sh ace-editor,analysis-core,antisamy-markup-formatter,apache-httpcomponents-client-4-api,authentication-tokens,bitbucket,bouncycastle-api,branch-api,build-pipeline-plugin,cloudbees-folder,command-launcher,conditional-buildstep,config-file-provider,credentials,credentials-binding,display-url-api,docker-build-step,docker-commons,docker-java-api,docker-plugin,durable-task,echarts-api,envinject,envinject-api,findbugs,git,git-client,git-server,h2-api,handlebars,jackson2-api,javadoc,jdk-tool,jenkins-design-language,job-dsl,jquery,jquery-detached,jquery3-api,jsch,junit,mailer,matrix-auth,matrix-project,maven-plugin,momentjs,multibranch-scan-webhook-trigger,multiple-scms,parameterized-trigger,pipeline-build-step,pipeline-graph-analysis,pipeline-input-step,pipeline-maven,pipeline-model-api,pipeline-model-definition,pipeline-model-extensions,pipeline-rest-api,pipeline-stage-step,pipeline-stage-tags-metadata,pipeline-stage-view,pipeline-utility-steps,plain-credentials,plugin-util-api,rebuild,run-condition,saferestart,scm-api,script-security,slack,snakeyaml-api,ssh-credentials,ssh-slaves,structs,token-macro,trilead-api,windows-slaves,workflow-api,workflow-basic-steps,workflow-cps,workflow-cps-global-lib,workflow-durable-task-step,workflow-job,workflow-multibranch,workflow-scm-step,workflow-step-api,workflow-support
service jenkins restart
cd ~
cat /var/lib/jenkins/secrets/initialAdminPassword

##### Docker Installation
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
service docker status

##### NEXUS Installation  - Port 8081
docker pull sonatype/nexus
docker run -d -p 8081:8081 --name nexus sonatype/nexus
sleep 20
curl http://localhost:8081/nexus/service/local/status

usermod -aG wheel centos

##### Maven Installation
rm -rf /usr/local/src/apache-maven
cd /usr/local/src
wget http://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xf apache-maven-3.6.3-bin.tar.gz
mv apache-maven-3.6.3/ apache-maven/ 
cd /etc/profile.d/

echo "# Apache Maven Environment Variables" > maven.sh
echo "# MAVEN_HOME for Maven 1 - M2_HOME for Maven 2" >> maven.sh
echo "export M2_HOME=/usr/local/src/apache-maven" >> maven.sh
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> maven.sh

chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version
cd ~
mkdir -p /home/jenkins/.m2/repository
chown jenkins:jenkins /home/jenkins/.m2/repository

##### Print Public IP address of Machine
curl icanhazip.com

#Update settings.xml - "/usr/local/src/apache-maven/conf/settings.xml" with this code
#<server>
#<id>nexus</id>
#      <username>admin</username>
#      <password>admin123</password>
#</server>

#cp /usr/local/src/apache-maven/conf/settings.xml /var/lib/jenkins/.m2/settings.xml
#chown -R jenkins:jenkins /var/lib/jenkins/.m2/settings.xml
#ls -l /var/lib/jenkins/.m2/settings.xml
