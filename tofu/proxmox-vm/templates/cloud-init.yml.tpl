#cloud-config
# Cloud-init configuration for Ansible-ready VMs

# System configuration
timezone: ${timezone}
locale: ${locale}

# Package management
package_update: true
package_upgrade: true
packages: ${jsonencode(additional_packages)}

# Users configuration
users:
  - name: ${ansible_user}
    groups:
      - sudo
      - adm
      - systemd-journal
    shell: /bin/bash
    sudo: "${ansible_sudo_config}"
    lock_passwd: false
    ssh_authorized_keys:
      - ${ansible_ssh_public_key}

# Enable password authentication for ansible user (optional)
ssh_pwauth: false

# System configuration
runcmd:
  # Create ansible facts directory
  - mkdir -p /etc/ansible/facts.d
  - chmod 755 /etc/ansible/facts.d

# Write files
write_files:
  - path: /etc/ansible/facts.d/deployment.fact
    content: |
      {
        "hostname": "$(hostname -f)",
        "short_hostname": "$(hostname -s)",
        "deployment_date": "$(date -u +%Y-%m-%d)",
        "deployment_time": "$(date -u +%H:%M:%S)",
        "terraform_managed": "true",
      }
    permissions: '0644'

