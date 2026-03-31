pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "rakeshkolipaka630" 
        IMAGE_TAG = "${BUILD_NUMBER}" 
        SONAR_HOME = tool "Sonar" 
        DOCKER_CREDS = "dockerhub-creds" 
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rakeshkolipakaace/Microservices-e-commerce.git',
                    credentialsId: 'github-creds'
            }
        }
        stage("Parallel Microservices Build") {
            parallel {
                stage('Ad Service') {
                    steps { script { buildService('adservice') } }
                }
                stage('Cart Service') {
                    steps { script { buildService('cartservice') } }
                }
                stage('Checkout Service') {
                    steps { script { buildService('checkoutservice') } }
                }
                stage('Currency Service') {
                    steps { script { buildService('currencyservice') } }
                }
                stage('Email Service') {
                    steps { script { buildService('emailservice') } }
                }
                stage('Frontend') {
                    steps { script { buildService('frontend') } }
                }
                stage('Load Generator') {
                    steps { script { buildService('loadgenerator') } }
                }
                stage('Payment Service') {
                    steps { script { buildService('paymentservice') } }
                }
                stage('Product Catalog') {
                    steps { script { buildService('productcatalogservice') } }
                }
                stage('Recommendation') {
                    steps { script { buildService('recommendationservice') } }
                }
                stage('Shipping Service') {
                    steps { script { buildService('shippingservice') } }
                }
                stage('Shopping Assistant') {
                    steps { script { buildService('shoppingassistantservice') } }
                }
            }
        }
    }
}

def buildService(String name) {
    echo "--- Starting Build for ${name} ---"
    
    // 1. Sonar Scan
    withSonarQubeEnv('SonarQube') {
        sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectName=${name} -Dsonar.projectKey=${name}"
    }
    
    // 2. OWASP Scan
    dependencyCheck additionalArguments: "--scan ./src/${name}", odcInstallation: 'Owasp'
    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
    
    // 3. Docker Build & Push
    dir("src/${name}") {
        sh "docker build -t ${name} ."
        withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
            sh "echo \$PASS | docker login -u \$USER --password-stdin"
            sh "docker tag ${name} ${DOCKER_HUB_USER}/${name}:${IMAGE_TAG}"
            sh "docker push ${DOCKER_HUB_USER}/${name}:${IMAGE_TAG}"
        }
    }
}
