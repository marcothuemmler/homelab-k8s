# Terraform Configuration

Provisions K8s node VMs from Ubuntu 24.04 cloud-init templates on Proxmox VE.

*Workflow:* `Ubuntu cloud image → cloud-init template → Terraform → Proxmox VMs`

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

## Configuration

**Resources:**
* `proxmox_vm_qemu` - VM instances cloned from template with cloud-init customization

**Key Variables:**
* `vms` - Map of VM configurations with optional defaults (memory: 2048MB, CPU: 2 cores, disk: 20G)
* `pm_api_token_id` / `pm_api_token_secret` - Proxmox API credentials (marked sensitive)
* `gateway_ip` - Default gateway for static IP configuration
* `sshkeys` - Public SSH keys injected via cloud-init

**Outputs:**
* `vm_ips` - Map of VM names to IPv4 addresses

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
