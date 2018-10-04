
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
                    sh 'mkdir -p bin'
                    sh 'mkdir -p tmp'
                    dir('tmp'){
                      git([ url: "https://github.internet2.edu/docker/util.git", credentialsId: "jenkins-github-access-token" ])
                      sh 'ls'
                      sh 'mv bin/* ../bin/.'
                    }
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
                   docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-$maintainer") {
                      def baseImg = docker.build("$maintainer/$imagename", "--no-cache .")
                      // scan the image with clair
                      sh 'docker run -p 5432:5432 -d --name clairdb arminc/clair-db:latest'
                      sh 'docker run -p 6060:6060 --link clairdb:postgres -d --name clair arminc/clair-local-scan:v2.0.5'
                      sh 'curl -L -o clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64'
                      sh 'chmod 755 clair-scanner'
                      sh "./clair-scanner --ip 172.17.0.1 -r test.out $maintainer/$imagename:latest"
                      // test the environment
                      sh 'docker kill clairdb'
                      sh 'docker rm clairdb'
                      sh 'docker kill clair'
                      sh 'docker rm clair'
                      sh 'cd test-compose && ./compose.sh'
                      // bring down after testing
                      sh 'cd test-compose && docker-compose down'
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
