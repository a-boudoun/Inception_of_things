#!/bin/bash
echo -e "\033[1;33m--Control plane provisioning--\033[0m"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

sudo apt-get update -y
sudo apt-get install net-tools
