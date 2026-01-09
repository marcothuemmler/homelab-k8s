# Proxmox + Kubernetes Homelab

![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-9.0.11-FF0000?logo=proxmox&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-1.14-623CE6?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-2.20+-EE0000?logo=ansible&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.35+-326CE5?logo=kubernetes&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?logo=ubuntu&logoColor=white)

Automated Kubernetes cluster deployment on Proxmox VE using infrastructure-as-code.

Combines Terraform for VM provisioning and Ansible for cluster configuration to deliver a reproducible K8s setup.

---

## Overview

This project automates the full lifecycle of deploying a Kubernetes cluster in a Proxmox homelab:

1. **Template Creation** - Build Ubuntu 24.04 cloud-init templates for consistent VM base images
2. **Infrastructure Provisioning** - Deploy VMs with Terraform using declarative configuration
3. **Cluster Configuration** - Install and configure Kubernetes components with Ansible

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

## Getting Started

See the individual component READMEs for detailed setup instructions:

1. **[Terraform Setup](terraform/README.md)** - Create templates and provision VMs
2. **[Ansible Setup](ansible/README.md)** - Deploy and configure Kubernetes cluster

---

## Architecture

```
Proxmox Host
    └── Ubuntu 24.04 Template (cloud-init)
        ├── k8s-master (control plane)
        └── k8s-worker-[1..N] (worker nodes)
```

VMs are provisioned via Terraform with cloud-init for initial configuration, then Ansible handles K8s-specific setup including containerd installation, kubeadm initialization, and worker node joining.

---

## Design Decisions

**Ubuntu over Talos**: Hands-on learning - setting up K8s from scratch, troubleshooting issues, and building transferable skills beyond a single opinionated distro.

**No rollback/DR**: Built for initial provisioning, not drift management. If setup fails, tear down and restart.

**Manual template creation**: One-time setup doesn't warrant automation. Also provides practice with Proxmox `qm` commands.
