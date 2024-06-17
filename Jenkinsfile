pipeline {
    agent any

    environment {
        DEPLOY_SERVER = "10.80.8.13"
        DEPLOY_USER = "tdnguyen2403" // Thay bằng tên người dùng trên server WordPress
        DEPLOY_PATH = "http://10.80.8.13/home" // Thay bằng đường dẫn thực tế đến thư mục WordPress của bạn
        REPO_URL = "https://github.com/tdnguyen2403/repo.git"
        SSH_CREDENTIALS_ID = "your_ssh_credentials_id" // Thay bằng ID của chứng chỉ SSH trong Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                // Kiểm tra mã nguồn từ repository
                git url: "${REPO_URL}", branch: 'main'
            }
        }

        stage('Backup Current Site') {
            steps {
                // Sao lưu trang web hiện tại
                sshagent (credentials: ["${SSH_CREDENTIALS_ID}"]) {
                    sh """
                        ssh ${DEPLOY_USER}@${DEPLOY_SERVER} 'tar -czf ${DEPLOY_PATH}/backup-$(date +%F-%H-%M-%S).tar.gz -C ${DEPLOY_PATH} .'
                    """
                }
            }
        }

        stage('Deploy New Version') {
            steps {
                // Triển khai phiên bản mới
                sshagent (credentials: ["${SSH_CREDENTIALS_ID}"]) {
                    sh """
                        rsync -avz --delete --exclude 'wp-config.php' . ${DEPLOY_USER}@${DEPLOY_SERVER}:${DEPLOY_PATH}
                    """
                }
            }
        }

        stage('Restart Web Service') {
            steps {
                // Khởi động lại dịch vụ web (nếu cần thiết)
                sshagent (credentials: ["${SSH_CREDENTIALS_ID}"]) {
                    sh """
                        ssh ${DEPLOY_USER}@${DEPLOY_SERVER} 'sudo systemctl restart apache2' // hoặc nginx, tùy theo dịch vụ web bạn sử dụng
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
