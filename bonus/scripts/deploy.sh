#!/bin/bash

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# create k3d cluster
echo -e "${YELLOW}Creating k3d cluster${NC}"
k3d cluster create bonus --config ./confs/k3d_cluster_config/k3d-cluster.yaml



# create gitlab resources
echo -e "${YELLOW}Creating gitlab resources${NC}"
kubectl create namespace gitlab
kubectl apply -n gitlab -f ./confs/gitlab/volumes.yaml
kubectl apply -n gitlab -f ./confs/gitlab/deployment.yaml
kubectl apply -n gitlab -f ./confs/gitlab/service.yaml

# wait gitlab pod to be ready
echo -e "${YELLOW}Waiting for GitLab to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=gitlab-ce -n gitlab --timeout=1500s

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# wait argocd pods to be ready
echo -e "${YELLOW}Waiting for Argo CD to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=500s

# change argocd server service type to NodePort
echo -e "${YELLOW}Configuring Argo CD server as NodePort${NC}"
kubectl patch svc argocd-server -n argocd --type='json' -p='[
  {"op": "replace", "path": "/spec/type", "value": "NodePort"},
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30002}
]'


# change gitlab repo url in argo_deploy/Application.yaml
GITLAB_IP=$(kubectl get svc gitlab-service -n gitlab -o jsonpath='{.spec.clusterIP}')
GITLAB_REPO_URL="http://$GITLAB_IP/root/k8s-deployment.git"
sed -i "s|repoURL: .*|repoURL: $GITLAB_REPO_URL|" ./confs/argo_deploy/Application.yaml

echo -e "${YELLOW}go to gitlab and create a public project named k8s-deployment${NC}"



argocdPassword=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "You can now access Argo CD at: ${GREEN}https://localhost:30002${NC} with the following credentials:"
echo -e "Username: ${GREEN}admin${NC}"
echo -e "Password: ${GREEN}$argocdPassword${NC}"


gitlabPassword=$(kubectl -n gitlab exec -it $(kubectl get pod -n gitlab -l app=gitlab-ce -o jsonpath='{.items[0].metadata.name}') -- cat /etc/gitlab/initial_root_password | grep Password: | awk '{print $2}')

echo $argocdPassword > credentials.txt
echo "-----" >> credentials.txt
echo $gitlabPassword >> credentials.txt

echo -e "You can now access GitLab at: ${GREEN}http://localhost:30000${NC} with the following credentials:"
echo -e "Username: ${GREEN}root${NC}"
echo -e "Password: ${GREEN}$gitlabPassword${NC}"


# kubectl create -f confs/argo_deploy/Application.yaml
