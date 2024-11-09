#!/usr/bin/env bash

echo "Starting the shell provisionner for the second machine..."

# install necessary tools
echo "Installing necesary tools..."
sudo apt install net-tools

echo "Set up K3S..."
SERVER_IP=$(</vagrant/confs/hostname.txt)
TOKEN=$(</vagrant/confs/node.txt)

echo "Hostname: $SERVER_IP"
echo "Token: $TOKEN"


curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -
