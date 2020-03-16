pipeline {
    agent any
    environment { 
        GROUP = 'viz.ai'
    }
    stages {
        stage('Test') {
            environment { 
                PHASE = 'test'
            }
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} for phase ${env.PHASE}"
                sh 'hostname' 
                dir('nginx') {
                    sh 'cat docker-compose.yml'
                }
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
                }
            }
            environment { 
                PHASE = 'prod'
                SSH_HOST = credentials('jenkins-viz-ai-ssh-host')
            }
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} for phase ${env.PHASE}"
                sh 'echo here we go!'
                withCredentials([sshUserPrivateKey(
                   credentialsId: 'jenkins-viz-ai', 
                   keyFileVariable: 'SSH_KEY_PATH', 
                   passphraseVariable: '', 
                   usernameVariable: 'SSH_USER' 
                )]){
                    sh 'hostname'
                    sh /* DEPLOY CODE TO WEBSERVER */ '''
                      echo $SSH_KEY_PATH
                      ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no ${SSH_USER}@${SSH_HOST} '
                          [ -f ~/repos ] || mkdir ~/repos;
                          cd repos;
                          [ -f ./viz-ai ] || git clone https://github.com/yosefrow/viz-ai.git;
                          cd viz-ai;
                          git pull origin master;
                          nginx/build.sh;
                      '
                    '''
                }
            }
        }
    }
}

