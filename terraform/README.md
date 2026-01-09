![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-9.0.11-FF0000?logo=proxmox&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-1.14-623CE6?logo=terraform&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange?logo=ubuntu&logoColor=white)

# Proxmox Terraform Config

This repo contains Terraform and shell scripts for provisioning Ubuntu 24.04 VMs in a Proxmox environment.  

It automates:

* Creating a reusable cloud-init template
* Deploying VMs from that template via Terraform
* Automated setup using cloud-init

*Workflow:* `Ubuntu cloud image → cloud-init template → Terraform → Proxmox VMs`

See [Terraform docs](https://developer.hashicorp.com/terraform/docs) and [cloud-init docs](https://cloudinit.readthedocs.io/en/latest/) for more details.

---

## Prerequisites

* [Proxmox VE 9+](https://www.proxmox.com/en/proxmox-ve)
* [Terraform 1.14+](https://www.terraform.io/)
* [Ubuntu 24.04 Cloud Image](https://cloud-images.ubuntu.com/releases/24.04/)

---

## Template Creation

Download the Ubuntu 24.04 cloud image and run:

```bash
./create_template.sh
```

This will:

* Create a VM configured for cloud-init
* Import the Ubuntu 24.04 cloud image
* Convert the VM into a reusable template

---

## Deploying VMs with Terraform

1. Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Fill in your **Proxmox API token**, gateway IP, SSH keys, and VM details in `terraform.tfvars`.

3. Initialize Terraform:

```bash
terraform init
```

4. Preview changes:

```bash
terraform plan
```

5. Apply changes to deploy VMs:

```bash
terraform apply
```
