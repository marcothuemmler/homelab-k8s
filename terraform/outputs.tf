output "vm_ips" {
  value       = { for k, v in proxmox_vm_qemu.vm : k => v.default_ipv4_address }
  description = "Primary IPv4 address of each VM via QEMU guest agent"
}
