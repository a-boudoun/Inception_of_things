#!/usr/bin/env bash

# Start shell provisioning
echo "Starting the shell provisioner for the first machine..."

# install necessary tools
echo "Installing necesary tools..."
sudo apt install net-tools

# set up k3S
echo "Set up K3S..."

# install k3s server
curl -sfL https://get.k3s.io | sh -

# use 644 for read-only access
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

sudo chmod 644 /var/lib/rancher/k3s/server/node-token
