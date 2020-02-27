
pipeline {
    agent any
    environment { 
        maintainer = "t"
        imagename = 'g'
        tag = 'l'
    }
    stages {
        stage('Setting build context') {
            steps {
                script {
                    maintainer = maintain()
                    imagename = imagename()
                    if(env.BRANCH_NAME == "master") {
                       tag = "latest"
                    } else {
                       tag = env.BRANCH_NAME
                    }
                    if(!imagename){
                        echo "You must define an imagename in common.bash"
                        currentBuild.result = 'FAILURE'
                     }
                    sh 'mkdir -p tmp && mkdir -p bin'
                    dir('tmp'){
                      git([ url: "https://github.internet2.edu/docker/util.git", credentialsId: "jenkins-github-access-token" ])
                      sh 'rm -rf ../bin/*'
                      sh 'mv ./bin/* ../bin/.'
                    }
                    // Build and test scripts expect that 'tag' is present in common.bash. This is necessary for both Jenkins and standalone testing.
                    // We don't care if there are more 'tag' assignments there. The latest one wins.
                    sh "echo >> common.bash ; echo \"tag=\\\"${tag}\\\"\" >> common.bash ; echo common.bash ; cat common.bash"
                }  
             }
        }    
        stage('Clean') {
            steps {
                script {
                   try{
                     sh 'bin/destroy.sh >> debug'
                   } catch(error) {
                     def error_details = readFile('./debug');
                     def message = "BUILD ERROR: There was a problem building the Base Image. \n\n ${error_details}"
                     sh "rm -f ./debug"
                     handleError(message)
                   }
                }
            }
        } 
        stage('Build') {
            steps {
                script {
                  try{
                      // statically defining jenkins credential value dockerhub-tier
                      docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-tier") {
                        baseImg = docker.build("$maintainer/$imagename", "--build-arg GROUPER_CONTAINER_VERSION=$tag --no-cache .")
                      }
                  } catch(error) {
                     def error_details = readFile('./debug');
                      def message = "BUILD ERROR: There was a problem building ${maintainer}/${imagename}:${tag}. \n\n ${error_details}"
                     sh "rm -f ./debug"
                     handleError(message)
                  }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                   try {
                     sh 'bin/test.sh 2>&1 | tee debug ; test ${PIPESTATUS[0]} -eq 0'
                   } catch (error) {
                     def error_details = readFile('./debug')
                     def message = "BUILD ERROR: There was a problem testing ${maintainer}/${imagename}:${tag}. \n\n ${error_details}"
                     sh "rm -f ./debug"
                     handleError(message)
                   } 
                }    
             }
        }
        
        stage('Push') {
            steps {
                script {
                        // statically defining jenkins credential value dockerhub-tier
                        docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-tier") {
                        baseImg.push("$tag")
                      }
                  }
            }
        }
        stage('Notify') {
            steps{
                echo "$maintainer"
                slackSend color: 'good', message: "$maintainer/$imagename:$tag pushed to DockerHub"
            }
        }
    }
    post { 
        always { 
            echo 'Done Building.'
        }
        failure {
            // slackSend color: 'good', message: "Build failed"
            handleError("BUILD ERROR: There was a problem building ${maintainer}/${imagename}:${tag}.")
        }
    }
}


def maintain() {
  def matcher = readFile('common.bash') =~ 'maintainer="(.+)"'
  matcher ? matcher[0][1] : 'tier'
}

def imagename() {
  def matcher = readFile('common.bash') =~ 'imagename="(.+)"'
  matcher ? matcher[0][1] : null
}

def handleError(String message){
  echo "${message}"
  currentBuild.setResult("FAILED")
  slackSend color: 'danger', message: "${message}"
  //step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: 'chubing@internet2.edu', sendToIndividuals: true])
  sh 'exit 1'
}
