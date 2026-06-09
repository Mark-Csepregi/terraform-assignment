#!/bin/bash
set -e

echo -e "\e[36m=== Starting Automated Local Kubernetes Deployment ===\e[0m"

# 1. Tooling Checks
for tool in minikube kubectl; do
    if ! command -v $tool &> /dev/null; then
        echo -e "\e[31mError: Required tool '$tool' is not installed.\e[0m" >&2
        exit 1
    fi
done
echo -e "\e[32m[✓] Tooling checks passed.\e[0m"

# 2. Automated Minikube Provisioning
if [ "$(minikube status --format='{{.Host}}' 2>/dev/null)" != "Running" ]; then
    echo "Minikube is stopped. Booting up local cluster..."
    minikube start
else
    echo -e "\e[32m[✓] Minikube is already active and running.\e[0m"
fi

# 3. Local Registry Image Build
echo "Building Docker image directly into Minikube's local container cache..."
minikube image build -t rest-app:local .

# 4. Automate Resource Deployment
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/

# 5. Delivery Verification & Localhost Binding
echo "Waiting for deployment to spin up..."
kubectl rollout status deployment/rest-app-deployment --timeout=60s

echo -e "\n\e[32m=================================================="
echo "🚀 Application successfully deployed!"
echo "Endpoint: http://localhost:8080/hello-world"
echo "Press Ctrl+C in this window to stop port-forwarding."
echo -e "==================================================\e[0m\n"

kubectl port-forward service/rest-app-service 8080:8080