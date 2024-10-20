#!/usr/bin/env bash


echo "Starting the shell provisioner..."

# set up ufw for k3s
# sudo ufw disable

# ufw allow 6443/tcp #apiserver
# ufw allow from 10.42.0.0/16 to any #pods
# ufw allow from 10.43.0.0/16 to any #services

# install k3s server

curl -sfL https://get.k3s.io | sh -

sudo chmod 777 /var/lib/rancher/k3s/server/

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/confs/node.txt

sudo hostname -I | awk '{print $2}' > /vagrant/confs/hostname.txt