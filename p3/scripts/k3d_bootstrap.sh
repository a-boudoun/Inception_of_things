#!/usr/bin/env bash

# Start shell provisioning
echo "Setup for K3d requirments..."

# install necessary tools
echo "Installing necesary tools..."
sudo apt install net-tools

# install docker for a ubuntu machine
echo "Installing Docker"

# clean any old packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install docker plugins
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# need to setup docker to run without sudo

# install Kubectl to interact with K3S cluster
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

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