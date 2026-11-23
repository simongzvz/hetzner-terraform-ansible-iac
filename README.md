# Hetzner Cloud Infrastructure as Code (Terraform & Ansible)

Automated provisioning and security hardening of a production-ready Ubuntu 24.04 cloud server on Hetzner Cloud using **Terraform** and **Ansible**.

## Architecture & Workflow

1. **Provisioning (Terraform):**
   - Reads an existing SSH public key from Hetzner Cloud (`data.hcloud_ssh_key`).
   - Creates a network-level Cloud Firewall allowing only SSH (`22`), HTTP (`80`), and HTTPS (`443`).
   - Provisions an Ubuntu 24.04 VPS (`cpx02` in `nbg1`).
   - Dynamically generates the Ansible inventory file (`ansible/inventory.ini`) with the newly assigned public IPv4 address.
2. **Configuration Management (Ansible):**
   - Updates system packages and installs essential security tools (`ufw`, `fail2ban`).
   - Creates a passwordless `sudo` admin user (`simon`) and copies authorized SSH keys.
   - Hardens SSH (`PermitRootLogin no`, `PasswordAuthentication no`).
   - Configures and enables UFW and Fail2ban.
   - Installs Docker Engine and the Docker Compose plugin.

## Usage

    # 1. Provide your Hetzner API token locally (ignored by Git)
    echo 'hcloud_token = "YOUR_HETZNER_API_TOKEN"' > terraform.tfvars

    # 2. Provision infrastructure
    terraform init
    terraform apply -auto-approve

    # 3. Configure and harden server
    cd ansible
    ansible-playbook playbook.yml

    # 4. Tear down infrastructure when no longer needed
    cd ..
    terraform destroy -auto-approve
