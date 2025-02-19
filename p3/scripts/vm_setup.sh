#!/bin/bash


echo  "installing necessary packages"

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install curl net-tools -y
echo  "installing docker"

sudo apt-get install docker.io -y
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER

# echo  "installing kubectl"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


echo  "installing k3d"

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash