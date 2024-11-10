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
sudo chmod 777 /etc/rancher/k3s/k3s.yaml

sudo chmod 777 /var/lib/rancher/k3s/server/

# create the deployments for the apps
echo "Creating the deployments..."
sudo kubectl create -f /vagrant/confs/portfolio_deployment.yaml

# setup Host Aliases in /etc/hosts file
echo "Setting up Host Aliases..."

# variables to store the IP and the domain name we want
IP="192.168.56.110"
DOMAINS=("app1.com" "app2.com" "app3.com")

# function that adds "$IP $domain" to the /etc/hosts file
add_host_alias(){
    # local variable that takes the first argument passed to the function
    local domain=$1

    # check if the host alias exist or not
    if ! grep -q "$IP $domain" /etc/hosts; then
        # if the alias doesn't exist, create one
        # append it to the file and silence the output of tee comand
        echo "$IP $domain" | sudo tee -a /etc/hosts > /dev/null
        echo "Added $domain alias to the /etc/hosts file."
    # if the alias exist
    else
        echo "$domain alias already exist in /etc/hosts."
    fi
}

for dom in "${DOMAINS[@]}"; do
    add_host_alias "$dom"
done