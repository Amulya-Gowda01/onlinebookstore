pipeline {
    agent any

    environment {
        IMAGE_NAME = "amulya78/onlinebookstore"
        CONTAINER_NAME = "onlinebookstore-container"
        APP_SERVER = "ubuntu@<APP_SERVER_PUBLIC_IP>"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Amulya-Gowda01/onlinebookstore.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $APP_SERVER "
                            docker pull $IMAGE_NAME:latest &&
                            docker stop $CONTAINER_NAME || true &&
                            docker rm $CONTAINER_NAME || true &&
                            docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME:latest
                        "
                    '''
                }
            }
        }
    }
}
