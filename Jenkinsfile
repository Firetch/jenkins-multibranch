pipeline {
    agent any
    environment {  
        DOCKER_HUB_LOGIN = credentials('docker-hub-roxs')
        INSTANCEDEV = "ec2-user@34.205.92.61"
        INSTANCETST = "ec2-user@3.238.14.130"
        INSTANCEPRD = "ec2-user@3.238.93.59"
        NAME ="node-app"
        REGISTRY="roxsross12"
        REPOSITORY="node-app-demo"
        VERSION="1.0.0"
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
               sh 'docker build -t $REGISTRY/$REPOSITORY:$VERSION .'
            }
        }
        stage('Docker Push to Docker-hub') {
            steps {
                sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                sh 'docker push $REGISTRY/$REPOSITORY:$VERSION' 
            }
        }
        stage('Deploy to EC2 to develop') {
            steps {
                echo 'DEPLOY'
                sh ("sed -i -- 's/NAME/$NAME/g' docker-compose.yml")
                sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
                sh ("sed -i -- 's/REPOSITORY/$REPOSITORY/g' docker-compose.yml")
                sh ("sed -i -- 's/VERSION/$VERSION/g' docker-compose.yml")
                sshagent(['ssh-ec2']){
                    sh 'scp -o StrictHostKeyChecking=no docker-compose.yml $INSTANCEDEV:/home/ec2-user'
                    sh 'ssh $INSTANCEDEV ls -lrt'
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