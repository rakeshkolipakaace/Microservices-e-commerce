$services = @(
    "adservice", "cartservice", "checkoutservice", "currencyservice",
    "emailservice", "frontend", "loadgenerator", "paymentservice",
    "productcatalogservice", "recommendationservice", "shippingservice",
    "shoppingassistantservice"
)

foreach ($service in $services) {
    Write-Host "--- Manually Patching SonarQube for $service ---"
    git checkout -f $service
    
    if (Test-Path "Jenkinsfile") {
        $content = Get-Content -Path "Jenkinsfile" -Raw
        
        # USE SINGLE QUOTES to avoid PowerShell interpolation of the target strings
        $target = 'Dsonar.projectKey=${IMAGE_NAME}'
        $replacement = 'Dsonar.projectKey=${IMAGE_NAME} -Dsonar.java.binaries=.'
        
        if ($content.Contains($target)) {
             if (-not $content.Contains("sonar.java.binaries")) {
                 $content = $content.Replace($target, $replacement)
                 [System.IO.File]::WriteAllText((Join-Path (Get-Location) "Jenkinsfile"), $content)
                 
                 git add Jenkinsfile
                 git commit -m "Fix: Added sonar.java.binaries to Jenkinsfile"
                 git push origin $service
                 Write-Host "Successfully patched $service"
             } else {
                 Write-Host "$service already patched."
             }
        } else {
             Write-Host "Target string not found in $service"
        }
    }
}

git checkout main
