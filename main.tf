terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
  required_version = "~> 1.14"
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

resource "proxmox_vm_qemu" "k8s_node" {
  for_each    = var.vms
  name        = each.key
  target_node = var.pm_node
  clone       = "ubuntu-24.04-template"
  full_clone  = true
  agent       = 1

  ciupgrade = true
  ciuser    = each.value.ciuser
  sshkeys   = var.sshkeys
  ipconfig0 = "ip=${each.value.ip},gw=${var.gateway_ip}"

  memory   = each.value.memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  cpu {
    cores   = each.value.cpu_cores
    sockets = each.value.cpu_sockets
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = each.value.disk_size
          storage = "local-lvm"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}
