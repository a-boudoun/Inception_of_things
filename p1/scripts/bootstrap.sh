#!/usr/bin/env bash


echo "Starting the shell provisioner..."

# sudo ufw disable

ufw allow 6443/tcp #apiserver
ufw allow from 10.42.0.0/16 to any #pods
ufw allow from 10.43.0.0/16 to any #services

