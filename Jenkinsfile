pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                bash 'hostname' 
                bash 'stat nginx' 
                bash 'cd nginx && cp .env.example .env && docker-compose config'
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                bash 'echo here we go!'
            }
        }
    }
}

