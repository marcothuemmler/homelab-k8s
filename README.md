# Homelab K8s Infrastructure

![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-9.0.11-FF0000?logo=proxmox&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-1.14-623CE6?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-2.20+-EE0000?logo=ansible&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.35+-326CE5?logo=kubernetes&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?logo=ubuntu&logoColor=white)

Automated Kubernetes infrastructure provisioning on Proxmox VE.

---

## Overview

This project automates Kubernetes infrastructure provisioning in a Proxmox homelab:

1. **Template Creation** - Build Ubuntu 24.04 cloud-init templates for consistent VM base images
2. **Infrastructure Provisioning** - Deploy VMs with Terraform using declarative configuration
3. **Cluster Configuration** - Install and configure Kubernetes components with Ansible

**Scope:** Infrastructure layer only - functional K8s nodes with pod networking. Platform services (ingress, monitoring, GitOps) and workload deployment are separate concerns.

**Tech Stack:**
* **Terraform** - VM provisioning and infrastructure management
* **Ansible** - Configuration management and K8s deployment
* **Proxmox VE** - Virtualization platform
* **Ubuntu 24.04** - Base OS with cloud-init
* **containerd** - Container runtime
* **Kubernetes** - Container orchestration

---

## Project Structure

```
.
├── terraform/          # VM provisioning with Terraform
│   ├── main.tf         # VM resource definitions
│   ├── variables.tf    # Input variables
│   └── README.md       # Detailed Terraform docs
└── ansible/            # K8s cluster configuration
    ├── cluster.yml     # Main playbook
    ├── roles/          # Ansible roles (common, containerd, k8s)
    └── README.md       # Detailed Ansible docs
```

---

## Quick Start

Use the Makefile for end-to-end deployment:

```bash
make all           # Provision VMs + deploy K8s cluster
```

Or run individual steps:

```bash
make init          # Initialize Terraform
make apply         # Provision VMs
make preflight     # Verify SSH connectivity
make deploy        # Deploy K8s cluster
make clean         # Destroy all infrastructure
```

## Getting Started

See the individual component READMEs for detailed setup instructions:

1. **[Terraform Setup](terraform/README.md)** - Create templates and provision VMs
2. **[Ansible Setup](ansible/README.md)** - Deploy and configure Kubernetes cluster

---

## Architecture

```
Template creation (qm)
  ↓
Terraform provisions VMs from template
  ↓
cloud-init (SSH keys, network config, user setup)
  ↓
Ansible configures all nodes (swap, kernel modules, containerd)
  ↓
kubeadm init on master node
  ↓
CNI deployment
  ↓
Token-based worker join
```

**Infrastructure:** 1 control plane node + N worker nodes on Proxmox VE. VMs cloned from Ubuntu 24.04 cloud-init template with Terraform, configured via Ansible roles.

---

## Design Decisions

**Ubuntu over Talos**: Direct experience with K8s components (kubeadm, kubelet, containerd), kernel tuning, and troubleshooting at the OS level. Talos abstracts these away.

**Infrastructure-only scope**: Stops at functional K8s nodes with pod networking. Clean separation of infrastructure and platform layers.

**Immutable infrastructure approach**: Failures trigger full teardown and redeploy rather than state reconciliation. Optimized for reproducibility over in-place repair.

**Manual template creation**: One-time setup doesn't warrant automation complexity.
