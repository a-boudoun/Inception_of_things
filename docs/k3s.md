# Deploy a POD and inspect it's infos:

![alt text](<Screen Shot 2024-10-23 at 12.33.04 PM.png>)


```bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
source ~/.bashrc
kubectl get all
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

# Deploy a Pod using YAML:

![alt text](pod_yaml1.png)
![alt text](pod_yaml2.png)

```yaml

apiVersion: v1
kind: Pod
metadata:
    name: my-pod-test
    labels:
        app: pod-app
        type: test-pod
spec:
    containers:
    - name: nginx-pod
      image: nginx

```

# ReplicationController:

![alt text](rc1.png)
![alt text](rc2.png)
![alt text](rc3.png)

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: rc-test
  labels:
    app: rc-app
    type: test-rc
spec:
  replicas: 3
  template:
    metadata:
      name: my-pod-test
      labels:
        app: pod-app
        type: test-pod
    spec:
      containers:
      - name: nginx-pod
        image: nginx
```

# ReplicaSet (Labels and Selectors):

![alt text](rs1.png)
![alt text](rs2.png)

## Scale:

![alt text](scale.png)

## Relevant commands:

![alt text](cmds.png)

# Deployment:

![alt text](deploy.png)

```yaml

# example of a deployment

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment-app
  labels:
    app: deploy-app
    type: test-deploy
spec:
  template:
    metadata:
      name: my-pod-app
      labels:
        app: pod-app
        type: test-pod
    spec:
      containers:
      - name: nginx-pod
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: test-pod

```


![alt text](deploy_after.png)

## Updates and Rollbacks:
### Rollout and versioning:

* after creating a new deployment: 

![alt text](rollout.png)

* after an update to the deployment:

![alt text](rollout_update.png)

* full review (it also creates a new replicaset):

![alt text](rollout_behave.png)

## todo:

- install netools in server agent 
- config k3s server agent (https://docs.k3s.io/installation/configuration)
- create eth1 for linux machines (agent/server)
- check why nodes create in server as well
![alt text](multiple_nodes.png)