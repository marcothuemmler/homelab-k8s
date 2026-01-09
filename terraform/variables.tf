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

variable "sshkeys" {
  type = string
}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    ciuser      = optional(string, "ubuntu")
    ip          = string # required
    memory      = optional(number, 2048)
    cpu_cores   = optional(number, 2)
    cpu_sockets = optional(number, 1)
    disk_size   = optional(string, "20G")
  }))
}
