variable "pm_api_url" {
  type = string # required
}

variable "pm_api_token_id" {
  type      = string
  sensitive = true
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "pm_node" {
  type    = string
  default = "proxmox"
}

variable "gateway_ip" {
  type = string # required
}

variable "sshkeys" {}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    ciuser      = string
    ip          = string # required
    memory      = number # required
    cpu_cores   = number # required
    cpu_sockets = number # required
    disk_size   = string # required
  }))
}
