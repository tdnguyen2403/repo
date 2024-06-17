pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-app-image'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", '.')
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").inside {
                        sh 'echo "Running tests..."'
                        // Thêm các lệnh kiểm thử cần thiết
                    }
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://my-docker-registry', 'docker-credentials-id') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sshagent(['your-ssh-credentials-id']) {
                        sh '''
                            ssh user@10.80.8.13 '
                            cd /path/to/your/docker-compose/file &&
                            docker-compose pull &&
                            docker-compose up -d
                            '
                        '''
                    }
                }
            }
        }
    }
}
