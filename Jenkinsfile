pipeline {
    agent any
    environment {  
        DOCKER_HUB_LOGIN = credentials('docker-hub-roxs')
    }
    stages {

        stage('install dependencies') {
            agent{
                docker {
                    image 'node:erbium-alpine'
                    args '-u root:root'
                }
            }
            steps {
                echo "Init"
                sh 'npm install'
            }
        }
        stage('Unit Test') {
            agent{
                docker {
                    image 'node:erbium-alpine'
                    args '-u root:root'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                sh 'npm run test'
                }
            }
        } 
        stage('Docker Build') {
            steps {
                echo "DOCKER Build"
            }
        }
        stage('Docker Push') {
            steps {
                echo "Docker Push"
            }
        }
        stage('Deploy to EC2') {
            steps {
                echo "Deploy to EC2"
                }
            }
        }

        stage('Notify Telegram') {
            steps {
                echo "NOTIFICACION TELEGRAM"
            }
        }

    } //--end stages

    // CLEAN WORKSPACES
    post { 
        always { 
            cleanWs()
        }
    }
}