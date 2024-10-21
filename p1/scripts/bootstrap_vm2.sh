#!/usr/bin/env bash

echo "Starting the shell provisionner for the second machine..."

# install Kubectl
echo "Installing Kubectl..."
curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Set up K3S..."
SERVER_IP=$(</vagrant/confs/hostname.txt)
TOKEN=$(</vagrant/confs/node.txt)

echo "Hostname: $SERVER_IP"
echo "Token: $TOKEN"


curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -
