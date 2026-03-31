pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "rakeshkolipaka630" 
        IMAGE_TAG = "\" 
        SONAR_HOME = tool "Sonar" 
        DOCKER_CREDS = "dockerhub-creds"
        SERVICE_NAME = "loadgenerator"
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: 'loadgenerator',
                    url: 'https://github.com/rakeshkolipakaace/Microservices-e-commerce.git',
                    credentialsId: 'github-creds'
            }
        }
        stage("Security & Build") {
            steps {
                script {
                    echo "--- Starting Full Security Flow for \ ---"
                    
                    withSonarQubeEnv('SonarQube') {
                        sh "\/bin/sonar-scanner -Dsonar.projectName=\ -Dsonar.projectKey=\"
                    }
                    
                    dependencyCheck additionalArguments: "--scan .", odcInstallation: 'Owasp'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                    
                    sh "trivy fs --format table -o trivy-\-fs-report.html ."
                    
                    sh "docker build -t \ ."

                    sh "trivy image --format table -o trivy-\-image-report.html \"
                    
                    withCredentials([usernamePassword(credentialsId: "\", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \\\ | docker login -u \\\ --password-stdin"
                        sh "docker tag \ \/\:\"
                        sh "docker push \/\:\"
                    }
                }
            }
        }
    }
    post {
        success { echo "Build and push of \ successful!" }
        failure { echo "Build and push of \ failed." }
    }
}
