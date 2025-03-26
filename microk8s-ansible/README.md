# MicroK8s Ansible Installation

This repository contains Ansible playbooks for installing and configuring MicroK8s on Ubuntu servers.

## Prerequisites

- Ansible installed on your local machine
- Python 3.x
- SSH access to the target server
- Ubuntu 18.04 or later on the target server
- Minimum 4GB RAM and 20GB disk space on the target server

## Configuration

Before running the playbook, you need to configure your target server in the `hosts` file:

1. Open `hosts` file and update the following values:
```ini
[microk8s_HA]
master ansible_ssh_host=YOUR_SERVER_IP

[all:vars]
ansible_ssh_user=root
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

Replace:
- `YOUR_SERVER_IP` with your server's IP address
- `~/.ssh/id_ed25519` with the path to your SSH private key

## Installation

1. Install Ansible if not already installed:
```bash
python3 -m pip install --user ansible
```

2. Install the required Ansible collection:
```bash
ansible-galaxy collection install -r requirements.yml
```

3. Run the playbook:
```bash
ansible-playbook -i hosts microk8s-playbook.yml
```

## What Gets Installed

The playbook installs MicroK8s with the following plugins enabled:

- DNS (1.1.1.1)
- Ingress
- Metrics Server
- Cert Manager
- OpenEBS
- Dashboard
- Storage
- Helm3
- MetalLB
- Prometheus
- Traefik
- Portainer

## Post-Installation

1. Access the Kubernetes cluster:
```bash
microk8s kubectl get nodes
```

2. Access the dashboard:
```bash
microk8s dashboard-proxy
```

3. Change the root password:
```bash
passwd root
```

## Security Notes

- The default root password is set to "test123" - this should be changed immediately after installation
- Ensure your SSH keys are properly secured
- Review and adjust the enabled plugins based on your security requirements

## Troubleshooting

If you encounter connection issues:
1. Verify the server is accessible via SSH
2. Check if the security group/firewall allows SSH access
3. Ensure the SSH key path is correct in the hosts file
4. Verify snapd is installed on the target system

## Files

- `requirements.yml`: Ansible collection dependencies
- `hosts`: Inventory file with server configurations
- `microk8s-playbook.yml`: Main playbook for MicroK8s installation 