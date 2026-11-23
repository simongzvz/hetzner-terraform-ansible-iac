# 1. Bereits vorhandenen SSH-Key aus Hetzner auslesen
data "hcloud_ssh_key" "macbook_key" {
  name = "lernturbo@MacBook-Air-von-Simon.local"
}

# 2. Cloud-Firewall direkt auf Netzwerk-Ebene vor dem Server
resource "hcloud_firewall" "web_fw" {
  name = "iac-base-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# 3. Den eigentlichen Cloud-Server (Ubuntu 24.04) erstellen
resource "hcloud_server" "iac_node" {
  name         = "iac-prod-01"
  image        = "ubuntu-24.04"
  server_type  = var.server_type
  location     = var.location
  ssh_keys     = [data.hcloud_ssh_key.macbook_key.id]
  firewall_ids = [hcloud_firewall.web_fw.id]
}

# 4. IP-Adresse automatisch in das Ansible-Inventory schreiben
resource "local_file" "ansible_inventory" {
  content  = "[webservers]\n${hcloud_server.iac_node.ipv4_address} ansible_user=root\n"
  filename = "${path.module}/ansible/inventory.ini"
}

# 5. Neue IP-Adresse nach dem Erstellen im Terminal ausgeben
output "server_ip" {
  description = "Öffentliche IPv4-Adresse des neuen Servers"
  value       = hcloud_server.iac_node.ipv4_address
}
