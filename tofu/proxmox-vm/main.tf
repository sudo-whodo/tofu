terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

# Configure the Proxmox Provider
provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # Optional: Skip TLS verification (not recommended for production)
  pm_tls_insecure = var.proxmox_tls_insecure

  # Optional: Enable debug logging
  pm_debug = var.proxmox_debug
}

# Local variables
locals {
  # Additional tags to apply to all VMs
  additional_tags = [
    "production"
  ]
}

# Create the VM with cloud-init
resource "proxmox_vm_qemu" "vm" {
  count = var.vm_count

  name        = "${var.vm_name_prefix}-${count.index + 1}"
  desc        = "VM managed by tofu"
  target_node = var.proxmox_node

  # Clone from template
  clone = var.template_name

  # VM configuration
  agent    = 1
  os_type  = "cloud-init"
  cores    = var.vm_cores
  sockets  = var.vm_sockets
  cpu      = var.vm_cpu_type
  memory   = var.vm_memory
  balloon  = 0
  scsihw   = "virtio-scsi-single"
  boot     = "order=ide3;scsi0"
  bios     = "seabios"
  automatic_reboot = false

  # Cloud-init settings
  ciuser     = var.cloud_init_user
  cipassword = var.cloud_init_password
  ipconfig0  = "ip=${var.vm_ip_base}.${var.vm_ip_start + count.index}/${var.vm_ip_netmask},gw=${var.vm_gateway}"
  nameserver = var.vm_nameservers
  sshkeys    = var.ansible_ssh_public_key  # Use ansible SSH key for the cloud-init user

  # Disk configuration
  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.vm_storage_pool
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size        = var.vm_disk_size
          storage     = var.vm_storage_pool
          emulatessd  = true
          discard     = true
          asyncio     = "native"
        }
      }
    }
  }

  # Network configuration
  network {
    model  = "virtio"
    bridge = var.vm_network_bridge
    tag    = var.vm_vlan_tag != -1 ? var.vm_vlan_tag : null
  }

  # VM lifecycle options
  onboot  = var.vm_onboot
  startup = var.vm_startup_order != "" ? var.vm_startup_order : null

  # Tags for organization
  tags = join(",", concat(
    ["tofu", "ansible_managed"],
    local.additional_tags
  ))

  # Wait for the QEMU guest agent to report an IP address
  agent_timeout = 120  # Wait up to 2 minutes for agent to start

  # Lifecycle management
  lifecycle {
    ignore_changes = [
      cipassword,  # Ignore password changes after initial creation
    ]
  }
}
