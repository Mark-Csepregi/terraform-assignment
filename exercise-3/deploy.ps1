Write-Host "=== Starting Automated Local Kubernetes Deployment ===" -ForegroundColor Cyan

# 1. Start Minikube (Safely skips if already running)
Write-Host "[1/4] Checking local cluster status..." -ForegroundColor Yellow
minikube start

# 2. Local Registry Image Build (No external registries needed)
Write-Host "[2/4] Building Docker image directly inside Minikube..." -ForegroundColor Yellow
minikube image build -t rest-app:local .

# 3. Apply the Kubernetes Configurations
Write-Host "[3/4] Applying Kubernetes manifests..." -ForegroundColor Yellow
kubectl apply -f k8s/

# 4. Wait for the Pod to be ready
Write-Host "[4/4] Waiting for application to pass health checks..." -ForegroundColor Yellow
kubectl rollout status deployment/rest-app-deployment --timeout=60s

Write-Host "`n==================================================" -ForegroundColor Green
Write-Host "🚀 Application successfully deployed!" -ForegroundColor Green
Write-Host "Endpoint: http://localhost:8080/hello-world" -ForegroundColor Green
Write-Host "Press Ctrl+C in this window to stop port-forwarding." -ForegroundColor Yellow
Write-Host "==================================================`n" -ForegroundColor Green

# 5. Open the network bridge to your machine
kubectl port-forward service/rest-app-service 8080:8080