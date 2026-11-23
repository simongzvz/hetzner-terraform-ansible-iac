variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Pfad zum lokalen SSH Public Key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "server_type" {
  description = "Hetzner Server-Modell"
  type        = string
  default     = "cpx02"
}

variable "location" {
  description = "Rechenzentrum (nbg1 = Nürnberg)"
  type        = string
  default     = "nbg1"
}
