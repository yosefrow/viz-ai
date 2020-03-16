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
                sh 'stat nginx' 
                sh 'ls'
                dir('nginx') {
                    sh """
                      set -a && . ./.env.example && cat docker-compose.yml | envsubst && set +a
                    """
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
            }
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} for phase ${env.PHASE}"
                sh 'echo here we go!'
            }
        }
    }
}

