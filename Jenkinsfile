pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "rakeshkolipaka630" 
        IMAGE_NAME = "paymentservice" 
        IMAGE_TAG = "${BUILD_NUMBER}" 
        REPO_URL = "${DOCKER_HUB_USER}/${IMAGE_NAME}" 
        SONAR_HOME = tool "Sonar" 
        DOCKER_CREDS = "dockerhub-creds" 
    }

    stages {
        stage("Checkout Code") {
            steps {
                checkout scm
            }
        }
        stage("SonarQube Scan") {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectName=${IMAGE_NAME} -Dsonar.projectKey=${IMAGE_NAME}"
                }
            }
        }
        stage("OWASP Dependency Check") {
            steps {
                dependencyCheck additionalArguments: '--scan .', odcInstallation: 'Owas'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Docker Build & Scan") {
            steps {
                script {
                    // Build the image using the Dockerfile in the root
                    sh "docker build -t ${IMAGE_NAME} ."
                    
                    // Run Trivy scan on the built image
                    sh "trivy image --format table -o trivy-image-report.html ${IMAGE_NAME}"
                }
            }
        }
        stage("Push to Docker Hub") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
                        sh "docker tag ${IMAGE_NAME} ${REPO_URL}:${IMAGE_TAG}"
                        sh "docker push ${REPO_URL}:${IMAGE_TAG}"
                    }
                }
            }
        }
    }
    post {
        success {
            echo "Pipeline for ${IMAGE_NAME} successful! Image was pushed to Docker Hub."
        }
        failure {
            echo "Pipeline for ${IMAGE_NAME} failed!"
        }
    }
}