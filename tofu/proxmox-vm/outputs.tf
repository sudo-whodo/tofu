# Output VM information
output "vm_ids" {
  description = "IDs of created VMs"
  value       = proxmox_vm_qemu.ansible_vm[*].id
}

output "vm_names" {
  description = "Names of created VMs"
  value       = proxmox_vm_qemu.ansible_vm[*].name
}

output "vm_ip_addresses" {
  description = "IP addresses of created VMs"
  value = [
    for i in range(var.vm_count) :
    "${var.vm_ip_base}.${var.vm_ip_start + i}"
  ]
}

output "ansible_inventory" {
  description = "Ansible inventory format for created VMs"
  value = join("\n", [
    for i in range(var.vm_count) :
    "${proxmox_vm_qemu.ansible_vm[i].name} ansible_host=${var.vm_ip_base}.${var.vm_ip_start + i} ansible_user=${var.ansible_user}"
  ])
}

output "ssh_connection_strings" {
  description = "SSH connection strings for each VM"
  value = [
    for i in range(var.vm_count) :
    "ssh ${var.ansible_user}@${var.vm_ip_base}.${var.vm_ip_start + i}"
  ]
}

output "vm_details" {
  description = "Detailed information about created VMs"
  value = {
    for i in range(var.vm_count) : proxmox_vm_qemu.ansible_vm[i].name => {
      id         = proxmox_vm_qemu.ansible_vm[i].id
      ip_address = "${var.vm_ip_base}.${var.vm_ip_start + i}"
      cores      = var.vm_cores
      memory     = var.vm_memory
      disk_size  = var.vm_disk_size
      node       = var.proxmox_node
      tags       = proxmox_vm_qemu.ansible_vm[i].tags
    }
  }
}

output "ansible_hosts_file" {
  description = "Content for Ansible hosts file"
  value = <<-EOT
[proxmox_vms]
${join("\n", [
    for i in range(var.vm_count) :
    "${proxmox_vm_qemu.ansible_vm[i].name} ansible_host=${var.vm_ip_base}.${var.vm_ip_start + i}"
  ])}

[proxmox_vms:vars]
ansible_user=${var.ansible_user}
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
}
