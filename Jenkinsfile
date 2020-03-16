pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'hostname' 
                sh 'stat nginx' 
                sh 'cd nginx && cp .env.example .env && docker-compose config'
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'echo here we go!'
            }
        }
    }
}

