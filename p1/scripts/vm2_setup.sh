#!/bin/bash

echo -e "\033[1;33m---Worker Node provisioning---\033[0m"

PRIVATE_KEY=/vagrant/.vagrant/machines/amiskiS/virtualbox/private_key
SERVER_IP="192.168.56.110"
CMD="sudo cat /var/lib/rancher/k3s/server/node-token | tr -d '\n'"

TOKEN=$(ssh  -o StrictHostKeyChecking=no -i $PRIVATE_KEY vagrant@$SERVER_IP -C $CMD)

echo -e "\033[1;33m$TOKEN\033[0m"
echo -e "\033[1;33m$SERVER_IP\033[0m"

curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -


sudo apt-get update -y
sudo apt-get install net-tools