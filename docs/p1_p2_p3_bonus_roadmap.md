# Part 1: K3s and Vagrant

### **Objective**
Part 1 focuses on setting up a minimal Kubernetes environment using K3s and Vagrant. You will create two virtual machines configured as a Kubernetes cluster with one server node and one worker node.

### **Requirements**

1. **Set Up Two Virtual Machines:**
   - Use Vagrant to create two virtual machines with minimal resources (1 CPU, 512–1024 MB RAM).
   - Assign static IPs to the VMs:
     - Server: `192.168.56.110`
     - Worker: `192.168.56.111`

2. **Naming Conventions:**
   - Name the VMs based on a team member’s login:
     - Server: `<login>S`
     - Worker: `<login>SW`

3. **SSH Configuration:**
   - Ensure passwordless SSH access is set up between the machines.

4. **K3s Installation:**
   - Install K3s in controller mode on the server VM.
   - Install K3s in agent mode on the worker VM, joining it to the server node.

5. **Verify Cluster Functionality:**
   - Install `kubectl` on the server machine.
   - Use `kubectl` to verify that both nodes are part of the cluster.

### **Expected Workflow**
1. **Set Up Vagrantfile:**
   - Write a Vagrantfile to define the two VMs with the above specifications.
   - Use provisioning scripts to automate K3s installation and configuration.

2. **Cluster Configuration:**
   - Configure the worker node to join the cluster by providing the appropriate token and server IP.
   - Ensure the cluster is functioning by running `kubectl get nodes`.

### **Deliverables**
- Include the Vagrantfile and provisioning scripts in a folder named `p1` at the root of your repository.
- Organize files into subfolders:
  - `p1/scripts`: Shell scripts for provisioning.
  - `p1/confs`: Configuration files if applicable.

---

# Part 2: K3s and Three Applications

### **Objective**
Part 2 builds on your K3s knowledge by deploying three web applications on a single K3s instance. You will use Ingress to manage access to these applications.

### **Requirements**

1. **Set Up a Single Virtual Machine:**
   - Use Vagrant to create a VM running K3s in server mode.
   - Assign it the static IP `192.168.56.110`.

2. **Deploy Three Applications:**
   - Create three web applications (or use simple placeholders, such as Nginx or custom containers).
   - Configure the applications to respond to different hostnames:
     - `app1.com` -> Application 1
     - `app2.com` -> Application 2 (with 3 replicas)
     - `app3.com` -> Application 3 (default route)

3. **Use Ingress for Routing:**
   - Set up Ingress rules to route requests based on the hostname.
   - Ensure requests to `app1.com`, `app2.com`, and any other hostname go to their respective applications.

4. **Replicas for Application 2:**
   - Deploy Application 2 with three replicas and verify load balancing.

### **Expected Workflow**
1. **Application Deployment:**
   - Write Kubernetes manifests (`deployment.yaml`, `service.yaml`, `ingress.yaml`) for each application.

2. **Ingress Configuration:**
   - Ensure Ingress is installed and configured in your K3s instance.
   - Test the setup by making HTTP requests to `192.168.56.110` with the appropriate host headers.

3. **Validation:**
   - Use `kubectl` to verify the deployment and scaling of applications.
   - Ensure the routing works as expected by testing with tools like `curl` or a web browser.

### **Deliverables**
- Include all Kubernetes manifests in a folder named `p2` at the root of your repository.
- Organize files into subfolders:
  - `p2/scripts`: Scripts for setting up Ingress or other dependencies.
  - `p2/confs`: Kubernetes manifests.

---

# Part 3: K3d and ArgoCD

### **Objective**
Part 3 focuses on transitioning your Kubernetes setup from K3s to K3d and leveraging ArgoCD for Continuous Deployment (CD). By the end of this part, you should:
1. Understand the difference between K3s and K3d.
2. Use ArgoCD to automate the deployment of applications to your Kubernetes cluster.
3. Deploy an application with multiple versions and manage updates via GitHub (GitOps approach = GitOps uses a Git repository as the single source of truth for infrastructure definitions).

### **Requirements**

1. **Setup K3d:**
   - Install and configure K3d on your virtual machine.
   - Ensure Docker is installed since K3d operates on top of Docker.

2. **ArgoCD Installation:**
   - Deploy ArgoCD in your K3d cluster.
   - Create a dedicated namespace named `argocd` for ArgoCD.
   - Make ArgoCD accessible via a port-forward, Ingress, or other means.

3. **GitHub Repository Setup:**
   - Create a public GitHub repository to host your Kubernetes manifests (e.g., `deployment.yaml`, `service.yaml`).
   - The repository name must include a team member's login.

4. **Deploy an Application:**
   - Deploy an application in a namespace named `dev` using ArgoCD.
   - The application should:
     - Have two versions (e.g., `v1` and `v2`).
     - Be available via a public Docker image, either your own or the provided image `wil42/playground`.
     - Expose itself on port 8888.

5. **Version Management:**
   - Demonstrate version control by:
     - Updating the application version in the GitHub repository (e.g., switching from `v1` to `v2`).
     - Verifying that ArgoCD detects the change and automatically updates the application in the cluster.

### **Expected Workflow**
1. **Initial Deployment:**
   - Push the Kubernetes manifests for version `v1` of the application to the GitHub repository.
   - Configure ArgoCD to sync with this repository and deploy the application to the `dev` namespace.

2. **Version Update:**
   - Modify the application version in the repository (e.g., update the image tag in `deployment.yaml` to `v2`).
   - Push the changes to GitHub.
   - Verify that ArgoCD detects the update and automatically rolls out the new version.

3. **Verification:**
   - Use commands like `kubectl get pods -n dev` and `curl` to confirm the deployment and version updates.

### **Deliverables**
- All configuration files (e.g., ArgoCD manifests, `deployment.yaml`, etc.) must be included in a folder named `p3` at the root of your repository.
- Include any necessary scripts in a `scripts` subfolder and configuration files in a `confs` subfolder.

---

# Bonus Part: GitLab Integration

### **Objective**
The bonus task extends Part 3 by replacing GitHub with a locally hosted GitLab instance. GitLab will act as the repository for your Kubernetes manifests and manage the CI/CD workflow with ArgoCD.

### **What is Expected in the Bonus?**

1. **GitLab Deployment in Kubernetes:**
   - Install and configure GitLab in your Kubernetes cluster (in the `gitlab` namespace, can use Helm to install GitLab (https://docs.gitlab.com/charts/installation/)).
   - Ensure GitLab is accessible locally, ideally via an Ingress or a LoadBalancer, depending on your setup.
   - Verify deployment (https://docs.gitlab.com/charts/installation/chart-provenance.html)

2. **Switch from GitHub to GitLab:**
   - In Part 3, you used GitHub as the source repository for ArgoCD to fetch your application’s deployment configurations.
   - Now, you need to migrate the repository to **GitLab**. Push all your configuration files (e.g., `deployment.yaml`, `service.yaml`, etc.) to a GitLab repository.

3. **CI/CD Integration with ArgoCD:**
   - Set up a connection between GitLab and ArgoCD so that ArgoCD automatically syncs your application deployments based on changes in the GitLab repository.
   - This means ArgoCD should now watch the **GitLab repository**, not GitHub, for updates.

4. **Application Versioning and Updates:**
   - Ensure that the application version update mechanism works seamlessly with GitLab. For example:
     - Update the application version in your GitLab repository (e.g., change from `v1` to `v2` in the `deployment.yaml` file).
     - Push the changes to GitLab.
     - Verify that ArgoCD detects the changes and automatically updates the application in the cluster.

5. **Keep Existing Functionality Intact:**
   - The rest of your setup from Part 3 must remain functional:
     - Two namespaces: `argocd` and `dev`.
     - ArgoCD managing deployments for the application in the `dev` namespace.
     - Proper application behavior (e.g., version updates).

### **How to Approach This?**
1. **Deploy GitLab:**
   - Use Helm to deploy GitLab in your Kubernetes cluster (`gitlab` namespace).
   - Make GitLab accessible via an Ingress rule (e.g., `http://gitlab.local`).

2. **Migrate Your Repository:**
   - Create a repository in GitLab.
   - Push all the files (from Part 3’s GitHub repo) to this new repository.

3. **Connect ArgoCD to GitLab:**
   - Update the ArgoCD configuration to use the new GitLab repository instead of GitHub.
   - Set up authentication between ArgoCD and GitLab (e.g., using a Personal Access Token or SSH key).

4. **Test the Workflow:**
   - Make changes in the GitLab repository (e.g., update the application version).
   - Verify that the cluster updates the application automatically through ArgoCD.

---

The line *"Configure Gitlab to make it work with your cluster"* in the bonus part means that after installing GitLab locally in your Kubernetes cluster (inside the `gitlab` namespace), you need to integrate it with your existing cluster so that it can manage deployments and CI/CD pipelines.

### Steps to Achieve This:
1. **Deploy GitLab in K3d**  
   - Install GitLab using Helm (recommended) or manually set up the necessary components.  
   - Ensure it runs in a dedicated namespace (`gitlab`).  
   - Configure persistent storage for GitLab's repositories, databases, and logs.

2. **Integrate GitLab with Kubernetes**  
   - In GitLab, navigate to **Admin Area > Kubernetes** and add your cluster.  
   - Provide the API URL (`https://kubernetes.default.svc` inside the cluster).  
   - Use a service account with the required permissions to allow GitLab to deploy applications.

3. **Enable GitLab Runner for CI/CD**  
   - Deploy **GitLab Runner** inside your cluster to execute jobs in GitLab CI/CD pipelines.  
   - Register the runner with your GitLab instance.

4. **Modify ArgoCD Configuration to Use GitLab**  
   - Ensure that ArgoCD pulls configuration from GitLab instead of GitHub.  
   - Update repository settings in ArgoCD to point to your GitLab repository.

5. **Test CI/CD Integration**  
   - Push a change to GitLab and verify that ArgoCD deploys the updated version of the application.

This setup ensures that everything you did in Part 3 (ArgoCD and automated deployments) works with your local GitLab instance instead of GitHub.

### **Summary**
- **Part 1:** Focuses on setting up a minimal K3s cluster using Vagrant.
- **Part 2:** Expands the K3s cluster by deploying multiple applications with Ingress-based routing.
- **Part 3:** Focuses on deploying an application using K3d and ArgoCD, with GitHub as the repository.
- **Bonus:** Enhances Part 3 by integrating a locally hosted GitLab instance, replacing GitHub, and maintaining all functionality.

