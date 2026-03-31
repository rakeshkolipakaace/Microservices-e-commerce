$services = @(
    "adservice", "cartservice", "checkoutservice", "currencyservice",
    "emailservice", "frontend", "loadgenerator", "paymentservice",
    "productcatalogservice", "recommendationservice", "shippingservice",
    "shoppingassistantservice"
)

foreach ($service in $services) {
    Write-Host "--- Migrating $service ---"
    
    # 1. Create a fresh branch from main
    git checkout main
    git pull origin main
    git checkout -b $service
    
    # 2. Preparation: Save the service code and Helm chart to a temporary directory
    $tempDir = "C:\Users\k.Rakesh\AppData\Local\Temp\jenkins-migration-$service"
    if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
    New-Item -ItemType Directory -Path $tempDir
    
    # Copy source code and helm chart
    if (Test-Path "src\$service") {
        Copy-Item -Recurse -Path "src\$service\*" -Destination $tempDir
    }
    
    $helmDest = Join-Path $tempDir "helm-chart"
    New-Item -ItemType Directory -Path $helmDest
    if (Test-Path "Helm\$service") {
        Copy-Item -Recurse -Path "Helm\$service\*" -Destination $helmDest
    }
    
    # 3. Create service-specific Jenkinsfile in tempDir
    $jenkinsContent = @"
pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "rakeshkolipaka630" 
        IMAGE_TAG = "\${BUILD_NUMBER}" 
        SONAR_HOME = tool "Sonar" 
        DOCKER_CREDS = "dockerhub-creds"
        SERVICE_NAME = "$service"
    }

    stages {
        stage("Checkout Code") {
            steps {
                git branch: '$service',
                    url: 'https://github.com/rakeshkolipakaace/Microservices-e-commerce.git',
                    credentialsId: 'github-creds'
            }
        }
        stage("Security & Build") {
            steps {
                script {
                    echo "--- Starting Full Security Flow for \${SERVICE_NAME} ---"
                    
                    withSonarQubeEnv('SonarQube') {
                        sh "\${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectName=\${SERVICE_NAME} -Dsonar.projectKey=\${SERVICE_NAME}"
                    }
                    
                    dependencyCheck additionalArguments: "--scan .", odcInstallation: 'Owasp'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                    
                    sh "trivy fs --format table -o trivy-\${SERVICE_NAME}-fs-report.html ."
                    
                    sh "docker build -t \${SERVICE_NAME} ."

                    sh "trivy image --format table -o trivy-\${SERVICE_NAME}-image-report.html \${SERVICE_NAME}"
                    
                    withCredentials([usernamePassword(credentialsId: "\${DOCKER_CREDS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \\\$PASS | docker login -u \\\$USER --password-stdin"
                        sh "docker tag \${SERVICE_NAME} \${DOCKER_HUB_USER}/\${SERVICE_NAME}:\${IMAGE_TAG}"
                        sh "docker push \${DOCKER_HUB_USER}/\${SERVICE_NAME}:\${IMAGE_TAG}"
                    }
                }
            }
        }
    }
    post {
        success { echo "Build and push of \${SERVICE_NAME} successful!" }
        failure { echo "Build and push of \${SERVICE_NAME} failed." }
    }
}
"@
    $jenkinsContent | Out-File -FilePath (Join-Path $tempDir "Jenkinsfile") -Encoding utf8
    
    # 4. Clear current branch and move temp files in
    git rm -rf .
    Copy-Item -Recurse -Path "$tempDir\*" -Destination "." -Force
    
    # 5. Clean up temp dir
    Remove-Item -Recurse -Force $tempDir
    
    # 6. Commit and Push
    git add .
    git commit -m "Dedicated branch for $service with separate Jenkinsfile and Helm chart"
    git push origin $service --force
    
    Write-Host "Migration of $service completed and pushed."
}

git checkout main
