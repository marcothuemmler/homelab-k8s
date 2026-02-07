# Kubernetes Cluster Setup

Ansible playbooks for deploying K8s on Ubuntu VMs.

The main playbook (`cluster.yml`) configures all nodes with containerd and K8s components, initializes the control plane, and joins worker nodes.

---

## Prerequisites

- Ansible 2.20+
- Ubuntu 24.04 VMs (provisioned via Terraform - see `../terraform/`)
- SSH access with sudo privileges

---

## Setup

1. Copy the example inventory:

    ```bash
    cp inventory.ini.example inventory.ini
    ```

2. Edit `inventory.ini` with your VM IPs:

    ```ini
    [k8s_master]
    k8s-master ansible_host=192.168.1.10
    
    [k8s_workers]
    k8s-worker1 ansible_host=192.168.1.11
    k8s-worker2 ansible_host=192.168.1.12
    
    [k8s_nodes:children]
    k8s_master
    k8s_workers
    ```

---

## Usage

Run preflight checks to verify connectivity:

```bash
ansible-playbook preflight.yml
```

Deploy the cluster:

```bash
ansible-playbook cluster.yml
```

Upgrade the cluster to a newer K8s version:

```bash
# Update k8s_version in group_vars/all.yml first
ansible-playbook upgrade.yml
```

Verify deployment:

```bash
kubectl get nodes
```

---

## Playbook Structure

### cluster.yml - Initial Deployment

Applies these roles in sequence:

**All nodes:**
- `common` - Disables swap and configures system settings
- `containerd` - Installs and configures container runtime
- `k8s_prereqs` - Installs kubeadm, kubelet, kubectl

**Control plane:**
- `k8s_master` - Runs kubeadm init and sets up pod network

**Worker nodes:**
- `k8s_worker` - Joins workers to the cluster using the token from master

### upgrade.yml - Version Upgrades

Applies these roles in sequence (one node at a time):

**Control plane:**
- `upgrade_control_plane` - Drains node, upgrades kubeadm/kubelet/kubectl, applies upgrade, uncordons

**Worker nodes:**
- `upgrade_worker` - Drains node, upgrades kubeadm/kubelet/kubectl, applies node upgrade, uncordons

## Configuration

**Key variables** (`group_vars/all.yml`):
- `k8s_version` - Kubernetes version (e.g., "1.35")
- `k8s_repo_url` - APT repository URL for K8s packages
- `pod_network_cidr` - Pod network CIDR (default: 10.244.0.0/16)
- `cni_manifest_url` - CNI manifest URL
