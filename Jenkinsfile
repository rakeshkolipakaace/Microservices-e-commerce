pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "rakeshkolipaka630" 
        IMAGE_TAG = "${BUILD_NUMBER}" 
        SONAR_HOME = tool "Sonar" 
        DOCKER_CREDS = "dockerhub-creds"
        SERVICE_NAME = "frontend"
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: 'frontend',
                    url: 'https://github.com/rakeshkolipakaace/Microservices-e-commerce.git',
                    credentialsId: 'github-creds'
            }
        }
        stage("Security & Build") {
            steps {
                script {
                    echo "--- Starting Full Security Flow for ${SERVICE_NAME} ---"
                    
                    withSonarQubeEnv('SonarQube') {
                        sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectName=${SERVICE_NAME} -Dsonar.projectKey=${SERVICE_NAME}"
                    }
                    
                    dependencyCheck additionalArguments: "--scan .", odcInstallation: 'Owas'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                    
                    sh "trivy fs --format table -o trivy-${SERVICE_NAME}-fs-report.html ."
                    
                    sh "docker build -t ${SERVICE_NAME} ."

                    sh "trivy image --format table -o trivy-${SERVICE_NAME}-image-report.html ${SERVICE_NAME}"
                    
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
                        sh "docker tag ${SERVICE_NAME} ${DOCKER_HUB_USER}/${SERVICE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${DOCKER_HUB_USER}/${SERVICE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
    }
    post {
        success { echo "Build and push of ${SERVICE_NAME} successful!" }
        failure { echo "Build and push of ${SERVICE_NAME} failed." }
    }
}