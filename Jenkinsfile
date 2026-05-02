pipeline {
    agent any

    environment {
        DEV_IMAGE = "krishnaprabhu616/dev:latest"
        PROD_IMAGE = "krishnaprabhu616/prod:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                credentialsId: 'github-creds',
                url: 'https://github.com/KrishnaPrabhuSampathu/React-APP.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp .'
            }
        }

        stage('Tag Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh "docker tag myapp $PROD_IMAGE"
                    } else {
                        sh "docker tag myapp $DEV_IMAGE"
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS')]) {

                    sh "echo $PASS | docker login -u $USER --password-stdin"

                    script {
                        if (env.BRANCH_NAME == 'main') {
                            sh "docker push $PROD_IMAGE"
                        } else {
                            sh "docker push $DEV_IMAGE"
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    def image = (env.BRANCH_NAME == 'main') ? PROD_IMAGE : DEV_IMAGE

                    sshagent(['ec2-ssh']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@54.198.109.5 '
                        docker pull ${image} &&
                        docker stop react-app || true &&
                        docker rm react-app || true &&
                        docker run -d -p 80:80 --name react-app ${image}
                        '
                        """
                    }
                }
            }
        }
    }
}