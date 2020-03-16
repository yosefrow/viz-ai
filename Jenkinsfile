pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'hostname' 
                sh 'cd nginx && ls' 
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'cd nginx'
                sh 'pwd'
            }
        }
    }
}

