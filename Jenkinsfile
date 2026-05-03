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

        // stage('Install Dependencies') {
        //     steps {
        //         sh 'npm install'
        //     }
        // }

        // stage('Build React App') {
        //     steps {
        //         sh 'npm run build'
        //     }
        // }


        // stage('Build Docker Image') {
        //     steps {
        //         sh 'docker build -t myapp .'
        //     }
        // }
        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh "docker build -t ${PROD_IMAGE} ."
                    } else {
                        sh "docker build -t ${DEV_IMAGE} ."
                    }
                }
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

        // stage('Push to DockerHub') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
        //             usernameVariable: 'USER',
        //             passwordVariable: 'PASS')]) {

        //             // sh "echo $PASS | docker login -u $USER --password-stdin"
        //             sh '''
        //             echo "$PASS" | docker login -u "$USER" --password-stdin
        //             '''

        //             script {
        //                 if (env.BRANCH_NAME == 'main') {
        //                     sh "docker push $PROD_IMAGE"
        //                 } else {
        //                     sh "docker push $DEV_IMAGE"
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('Push to DockerHub') {
        //     when {
        //         anyOf {
        //             branch 'dev'
        //             branch 'main'   
        //         }
        //     }
        //     steps {
        //         withCredentials([usernamePassword(
        //             credentialsId: 'dockerhub-creds',
        //             usernameVariable: 'DOCKERHUB_USER',
        //             passwordVariable: 'DOCKERHUB_PASS'
        //         )]) {

        //             sh '''
        //                 echo "$DOCKERHUB_PASS" | docker login \
        //                     -u "$DOCKERHUB_USER" \
        //                     --password-stdin
        //             '''

        //             script {
        //                 if (env.BRANCH_NAME == 'dev') {
        //                     echo "Pushing development image to Docker Hub DEV repository..."
        //                     sh """
        //                         docker tag ${APP_IMAGE}:${BUILD_NUMBER} ${DEV_IMAGE}:${BUILD_NUMBER}
        //                         docker tag ${APP_IMAGE}:${BUILD_NUMBER} ${DEV_IMAGE}:latest
        //                         docker push ${DEV_IMAGE}:${BUILD_NUMBER}
        //                         docker push ${DEV_IMAGE}:latest
        //                     """
        //                 }
        //                 else if (env.BRANCH_NAME == 'main') { 
        //                     echo "Pushing production image to Docker Hub PROD repository..."
        //                     sh """
        //                         docker tag ${APP_IMAGE}:${BUILD_NUMBER} ${PROD_IMAGE}:${BUILD_NUMBER}
        //                         docker tag ${APP_IMAGE}:${BUILD_NUMBER} ${PROD_IMAGE}:latest
        //                         docker push ${PROD_IMAGE}:${BUILD_NUMBER}
        //                         docker push ${PROD_IMAGE}:latest
        //                     """
        //                 }
        //                 else {
        //                     echo "Branch ${env.BRANCH_NAME} is not configured for Docker push."
        //                 }
        //             }

        //             sh 'docker logout'
        //         }
        //     }
        // }        

        stage('Push to DockerHub') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'main'
                }
            }

            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {

                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login \
                            -u "$DOCKERHUB_USER" \
                            --password-stdin
                    '''

                    script {
                        if (env.BRANCH_NAME == 'dev') {
                            echo "Pushing DEV image..."
                            sh """
                                docker push ${DEV_IMAGE}
                            """
                        }
                        else if (env.BRANCH_NAME == 'main') {
                            echo "Pushing PROD image..."
                            sh """
                                docker push ${PROD_IMAGE}
                            """
                        }
                    }

                    sh 'docker logout'
                }
            }
        }
        // stage('Deploy to EC2') {
        //     steps {
        //         script {
        //             def image = (env.BRANCH_NAME == 'main') ? PROD_IMAGE : DEV_IMAGE

        //             sshagent(['ec2-ssh']) {
        //                 sh """
        //                 ssh ubuntu@13.222.194.219 '
        //                 sudo docker pull ${image} &&
        //                 sudo docker stop react-app || true &&
        //                 sudo docker rm react-app || true &&
        //                 sudo docker run -d -p 80:80 --name react-app ${image}
        //                 '
        //                 """
        //             }
        //         }
        //     }
        // }

        // stage('Deploy to EC2') {
        //     steps {
        //         script {
        //             def image = (env.BRANCH_NAME == 'main') ? PROD_IMAGE : DEV_IMAGE

        //             sshagent(['ec2-ssh']) {
        //                 sh """
        //                     ssh -o StrictHostKeyChecking=no ubuntu@13.222.194.219 '
        //                         sudo docker pull ${image} &&
        //                         sudo docker stop react-app || true &&
        //                         sudo docker rm react-app || true &&
        //                         sudo docker run -d -p 80:80 --name react-app ${image}
        //                     '
        //                 """
        //             }
        //         }
        //     }
        // }   

        stage('Deploy to EC2') {
            steps {
                script {

                    def image = (env.BRANCH_NAME == 'main')
                        ? "krishnaprabhu616/prod:latest"
                        : "krishnaprabhu616/dev:latest"

                    def composeFile = (env.BRANCH_NAME == 'main')
                        ? "docker-compose.prod.yml"
                        : "docker-compose.dev.yml"

                    sshagent(['ec2-ssh']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@13.222.194.219 '
                                docker pull ${image} &&
                                cd /home/ubuntu &&
                                docker compose -f ${composeFile} down || true &&
                                docker compose -f ${composeFile} up -d
                            '
                        """
                    }
                }
            }
        }         
    }
}