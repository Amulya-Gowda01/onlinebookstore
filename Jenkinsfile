pipeline {
    agent any

    environment {
        IMAGE_NAME = "amulya78/onlinebookstore"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/Amulya_Gowda01/Onlinebookstore-public.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop onlinebookstore || true
                docker rm onlinebookstore || true
                docker run -d -p 8081:80 --name onlinebookstore $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

    }
}
