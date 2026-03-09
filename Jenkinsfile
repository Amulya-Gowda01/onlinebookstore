pipeline {
    agent any

    environment {
        IMAGE_NAME = "amulya78/onlinebookstore"
        CONTAINER_NAME = "onlinebookstore-container"
        APP_SERVER = "ec2-user@13.233.163.69"
    }

    stages {
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
                sshagent(credentials: ['ec2-ssh-key']) {
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
