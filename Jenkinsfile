def slackChannel = "#demoapp_alerts"

node() {
  properties([[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '5']]])
  deleteDir()

  try {
    stage("SCM Checkout") {
      //checkoutGit('master', "DemoJavaApp", "https://github.com/ramkannan-s/clark_cloud_app.git", '')
      checkout scm
    }
    
    stage("Decrypt and update value in ec2 yaml") {
      withCredentials([file(credentialsId: 'GIT_CRYPT_PRIVATE_KEY', variable: 'invkey')]) {
        sh """
          git-crypt unlock $invkey
        """
      }
    }

    stage("Deploy App using Ansible") {
        sh """
        ansible-playbook -i aws_ec2.yaml -u ubuntu --private-key=/home/jenkins/experiment-clark-key-pair.pem deploy_app.yml -v
      """
    }

    stage("Post Build") {
      currentBuild.displayName = "DemoApp-${env.BUILD_NUMBER}" 
      slackSuccess(slackChannel)
    }

  } catch (err) {
      println("================ ERROR: ${err}")
		  currentBuild.displayName = "DemoApp-${env.BUILD_NUMBER}" 
      slackFailure(slackChannel)
      currentBuild.result = "FAILURE"
      error()
  }
}

def checkoutGit(branchName, targetDir, repoURL, credID) {
    checkout([$class: 'GitSCM',
      branches: [[name: branchName]],
      doGenerateSubmoduleConfigurations: false,
      extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: targetDir]],
      submoduleCfg: [],
      userRemoteConfigs: [[credentialsId: credID, url: repoURL]]
    ])
}

def slackSuccess(slackChannel) {
    slackSend (
        channel: slackChannel,
        color: "#008000",
        message: ":blush: *SUCCESS*\n_Deployment_ Completed in DEV for *${currentBuild.displayName}*.\nBuild URL - ${env.BUILD_URL}")
}

def slackFailure(slackChannel) {
    slackSend (
        channel: slackChannel,
        color: "#FF0000",
        message: ":dizzy_face: *FAILURE*\n_Deployment_ Failed in DEV for *${currentBuild.displayName}*.\nBuild URL - ${env.BUILD_URL}")
}