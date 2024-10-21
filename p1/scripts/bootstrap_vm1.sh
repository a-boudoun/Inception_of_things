#!/usr/bin/env bash

# Start shell provisioning
echo "Starting the shell provisioner for the first machine..."

# install Kubectl
echo "Installing Kubectl..."
curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# set up k3S
echo "Set up K3S..."

# set up ufw for k3s
# sudo ufw disable

# ufw allow 6443/tcp #apiserver
# ufw allow from 10.42.0.0/16 to any #pods
# ufw allow from 10.43.0.0/16 to any #services

# install k3s server

curl -sfL https://get.k3s.io | sh -

sudo chmod 777 /etc/rancher/k3s/k3s.yaml

sudo chmod 777 /var/lib/rancher/k3s/server/

sudo cat /var/lib/rancher/k3s/server/node-token | tr -d '\n' > /vagrant/confs/node.txt

sudo hostname -I | awk '{print $2}' | tr -d '\n' > /vagrant/confs/hostname.txt

# run server
sudo k3s server


# no conection with k3s, potemtial problem with the firewall