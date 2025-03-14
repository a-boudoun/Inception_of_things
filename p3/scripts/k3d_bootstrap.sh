#!/usr/bin/env bash

# Start shell provisioning
echo "Setting up K3d requirements..."

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install necessary tools (if not installed)
echo "Installing necessary tools..."
if ! command -v netstat &>/dev/null; then
    sudo apt install -y net-tools
else
    echo "net-tools already installed, skipping..."
fi

# Install kubectl to interact with k3d cluster if not installed
if ! command -v kubectl &>/dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0777 kubectl /usr/local/bin/kubectl
    sudo chown $(whoami):$(whoami) /usr/local/bin/kubectl
    chmod +x /usr/local/bin/kubectl
    echo "kubectl installed successfully!"
else
    echo "kubectl already installed, skipping..."
fi

# Install K3d if not installed
if ! command -v k3d &>/dev/null; then
    echo "Installing K3d..."
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo "K3d installed successfully!"
else
    echo "K3d already installed, skipping..."
fi

# Create K3d cluster
echo "Creating K3d cluster..."
k3d cluster create --config ../confs/k3d_cluster_config/iot-k3d-cluster.yaml

# Ensure kubectl is using the correct K3d context
kubectl config use-context k3d-iot-k3d-cluster

# Create namespaces
# argocd namespace will be created within its config file argo_deploy.yaml
kubectl create namespace dev

# Install ArgoCD in the k3d cluster
echo "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Change ArgoCD service to NodePort
echo "Exposing ArgoCD via NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Forward ArgoCD service port
echo "Forwarding ArgoCD port..."
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 &>/dev/null &

# Ensure ArgoCD CLI is installed
if ! command -v argocd &>/dev/null; then
    echo "Installing ArgoCD CLI..."
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 777 argocd-linux-amd64 /usr/local/bin/argocd
    echo "ArgoCD CLI installed successfully!"
else
    echo "ArgoCD CLI already installed, skipping..."
fi

# Retrieve the ArgoCD admin password
echo "Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PASSWORD"

# Log in to ArgoCD
echo "Logging in to ArgoCD..."
argocd login localhost:8080 --username admin --password "$ARGOCD_PASSWORD" --insecure

# Deploy ArgoCD applications
echo "Deploying applications in ArgoCD..."
kubectl apply -f ../confs/argo_deploy.yaml

echo "Setup completed successfully!"
