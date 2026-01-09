# Kubernetes Cluster Setup

Ansible playbooks for deploying K8s on Ubuntu VMs.

The main playbook (`cluster.yml`) configures all nodes with containerd and K8s components, initializes the control plane, and joins worker nodes.

---

## Usage

Edit `inventory.ini` with your VM IPs:

```ini
[k8s_master]
k8s-master ansible_host=192.168.1.10

[k8s_workers]
k8s-worker1 ansible_host=192.168.1.11
k8s-worker2 ansible_host=192.168.1.12
```

Deploy the cluster:

```bash
ansible-playbook cluster.yml
```

Verify deployment:
```bash
kubectl get nodes
```

---

## Playbook Structure

`cluster.yml` applies these roles in sequence:

**All nodes:**
- `common` - Disables swap and configures system settings
- `containerd` - Installs and configures container runtime
- `k8s_prereqs` - Installs kubeadm, kubelet, kubectl

**Master node:**
- `k8s_master` - Runs kubeadm init and sets up pod network

**Worker nodes:**
- `k8s_worker` - Joins workers to the cluster using the token from master

---

## Requirements

- Ansible 2.20+
- Ubuntu 24.04 VMs (provisioned via Terraform - see `../terraform/`)
- SSH access with sudo privileges
