resource "proxmox_vm_qemu" "vm" {
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

  memory = each.value.memory
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0"

  start_at_node_boot = true

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

  # 
  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
}
