#!/usr/bin/env bash


# create dedicated namespace for gitlab:
kubectl create namespace gitlab

# deploy using Helm

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com

# can add Verifying the integrity and origin of GitLab Helm charts

# Initial login 

kubectl get secret <name>-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
