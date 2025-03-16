#!/bin/bash

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

echo -e "${YELLOW}Creating k3d cluster${NC}"

k3d cluster create p3 --config ./confs/k3d_cluster_config/k3d-cluster.yaml

kubectl cluster-info > /dev/null 

if [ $? -eq 0 ]; then
    echo -e "${GREEN}k3d cluster created successfully!${NC}"
else
    echo -e "${RED}Error: k3d cluster creation failed.${NC}"
    exit 1
fi

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml



# wait argocd pods to be ready
echo -e "${YELLOW}Waiting for Argo CD to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s


echo -e "${YELLOW}Configuring Argo CD server as NodePort${NC}"

kubectl patch svc argocd-server -n argocd --type='json' -p='[
  {"op": "replace", "path": "/spec/type", "value": "NodePort"},
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30001}
]'


echo -e "${YELLOW}creating argocd Application${NC}"

kubectl apply -n argocd -f ./confs/argo_deploy/Application.yaml

argocdPassword=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo -e "${GREEN}You can now access Argo CD at: https://localhost:30001${NC} with the following credentials:"
echo -e "${GREEN}Username: admin${NC}"
echo -e "${GREEN}Password: $argocdPassword${NC}"

