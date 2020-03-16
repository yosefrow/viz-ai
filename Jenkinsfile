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
            }
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL} for phase ${env.PHASE}"
                sh 'echo here we go!'
            }
        }
    }
}

