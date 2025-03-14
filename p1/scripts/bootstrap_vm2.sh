#!/usr/bin/env bash

echo "Starting the shell provisionner for the second machine..."

# install necessary tools
echo "Installing necesary tools..."
sudo apt install net-tools

echo "Set up K3S..."

PRIVATE_KEY=/vagrant/.vagrant/machines/aboudounS/virtualbox/private_key
SERVER_IP="192.168.56.110"
CMD="sudo cat /var/lib/rancher/k3s/server/node-token | tr -d '\n'"

TOKEN=$(ssh  -o StrictHostKeyChecking=no -i $PRIVATE_KEY vagrant@$SERVER_IP -C $CMD)


curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -