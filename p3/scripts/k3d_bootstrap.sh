#!/usr/bin/env bash

# Start shell provisioning
echo "Setup for K3d requirments..."

# install necessary tools
echo "Installing necesary tools..."
sudo apt install net-tools


# install Kubectl to interact with K3S cluster
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0777 kubectl /usr/local/bin/kubectl

# set up k3d
echo "Install up K3d..."
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

k3d cluster create --config ../confs/k3d_cluster_config/iot-k3d-cluster.yaml

# creating the namespaces
kubectl create namespace dev && kubectl create namespace argocd


# install argocd in the k3d cluster (the k3s context should be of k3d)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# need to set up argocd after (maybe use ingress)
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# temp:
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# login to argocd:
ARGOCD_PASSWORD=$(sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)

# will get a certificate warning
sudo argocd login localhost:8080

#might need to change password
# sudo argocd account update-password

# deploy in argocd
kubectl apply -f ../confs/argo_deploy.yaml