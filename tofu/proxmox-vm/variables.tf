# Proxmox Provider Variables
variable "proxmox_api_url" {
  description = "The URL of the Proxmox API (e.g., https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "The Proxmox API token ID (e.g., user@pam!token-name)"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "The Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The name of the Proxmox node to deploy VMs on"
  type        = string
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS certificate verification (not recommended for production)"
  type        = bool
  default     = false
}

variable "proxmox_debug" {
  description = "Enable debug logging for Proxmox provider"
  type        = bool
  default     = false
}

# VM Template Variables
variable "template_name" {
  description = "Name of the VM template to clone from"
  type        = string
}

# VM Configuration Variables
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "ansible-vm"
}

variable "vm_cores" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 2
}

variable "vm_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "vm_cpu_type" {
  description = "CPU type for the VM"
  type        = string
  default     = "host"
}

variable "vm_memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Size of the VM disk (e.g., 20G)"
  type        = string
  default     = "20G"
}

variable "vm_storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
  default     = "local-lvm"
}

# Network Configuration Variables
variable "vm_network_bridge" {
  description = "Network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "vm_vlan_tag" {
  description = "VLAN tag for network interface (-1 for no VLAN)"
  type        = number
  default     = -1
}

variable "vm_ip_base" {
  description = "Base IP address for VMs (e.g., 192.168.1)"
  type        = string
}

variable "vm_ip_start" {
  description = "Starting IP address number (will be appended to vm_ip_base)"
  type        = number
  default     = 100
}

variable "vm_ip_netmask" {
  description = "Network mask (e.g., 24)"
  type        = number
  default     = 24
}

variable "vm_gateway" {
  description = "Gateway IP address"
  type        = string
}

variable "vm_nameservers" {
  description = "DNS nameservers"
  type        = string
  default     = "8.8.8.8 8.8.4.4"
}

# Cloud-init Configuration Variables
variable "cloud_init_user" {
  description = "Default cloud-init user"
  type        = string
  default     = "ubuntu"
}

variable "cloud_init_password" {
  description = "Default cloud-init user password (leave empty for SSH key only access)"
  type        = string
  default     = ""
  sensitive   = true
}

# Ansible Configuration Variables
variable "ansible_user" {
  description = "Username for Ansible user"
  type        = string
  default     = "ansible"
}

variable "ansible_ssh_public_key" {
  description = "SSH public key for Ansible user"
  type        = string
}

variable "ansible_sudo_config" {
  description = "Sudo configuration for Ansible user"
  type        = string
  default     = "ALL=(ALL) NOPASSWD:ALL"
}

variable "create_custom_cloud_init" {
  description = "Whether to create custom cloud-init configuration"
  type        = bool
  default     = false
}

variable "additional_packages" {
  description = "Additional packages to install via cloud-init"
  type        = list(string)
  default = [
    "python3",
    "python3-pip",
    "sudo",
    "curl",
    "wget",
    "vim",
    "htop"
  ]
}

# VM Lifecycle Variables
variable "vm_onboot" {
  description = "Start VM on boot"
  type        = bool
  default     = true
}

variable "vm_startup_order" {
  description = "Startup order for VM (empty string for no specific order)"
  type        = string
  default     = ""
}

# Localization Variables
variable "timezone" {
  description = "Timezone for the VMs"
  type        = string
  default     = "UTC"
}

variable "locale" {
  description = "Locale for the VMs"
  type        = string
  default     = "en_US.UTF-8"
}
