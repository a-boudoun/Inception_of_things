#!/usr/bin/env bash

# Start shell provisioning
echo "Starting the shell provisioner for the first machine..."

# install Kubectl
echo "Installing Kubectl..."
curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# set up k3S
echo "Set up K3S..."

# install k3s server

curl -sfL https://get.k3s.io | sh -

sudo chmod 777 /etc/rancher/k3s/k3s.yaml

sudo chmod 777 /var/lib/rancher/k3s/server/

sudo cat /var/lib/rancher/k3s/server/node-token | tr -d '\n' > /vagrant/confs/node.txt

sudo hostname -I | awk '{print $2}' | tr -d '\n' > /vagrant/confs/hostname.txt
