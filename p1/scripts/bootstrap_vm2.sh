#!/usr/bin/env bash

echo "Starting the shell provisionner for the second machine..."

SERVER_IP=$(</vagrant/confs/hostname.txt)
TOKEN=$(</vagrant/confs/node.txt)

echo "Hostname: $SERVER_IP"
echo "Token: $TOKEN"


curl -sfL https://get.k3s.io | K3S_URL=https://SERVER_IP:6443 K3S_TOKEN=TOKEN sh -

# sudo k3s agent --server https://myserver:6443 --token ${TOKEN}