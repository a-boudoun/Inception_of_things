![alt text](<Screen Shot 2024-10-23 at 12.33.04 PM.png>)


```bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
source ~/.bashrc
kubectl get pods
kubectl get pods -all 
kubectl get pods -A 
kubectl get nodes
kubectl run nginx --image nginx 
kubectl get pods 
kubectl cluster-info 
kubectl get pods 
kubectl get nodes 
kubectl describe nodes 
kubectl get pods -o wide 
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
kubectl get pods -o wide --all-namespaces --sort-by="{.spec.nodeName}" 
```
