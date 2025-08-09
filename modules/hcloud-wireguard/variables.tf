variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "server_name" {
  type    = string
  default = "wg-server"
}

variable "server_type" {
  type    = string
  default = "cpx11"
}

variable "location" {
  type    = string
  default = "ash"
}

variable "ssh_key_names" {
  type    = list(string)
  default = []
}
variable "ssh_keys_selector" {
  type    = string
  default = null
}

variable "firewall_name" {
  type    = string
  default = "wg-firewall"
}

variable "wireguard_port" {
  type        = string
  default     = "51820"
  description = "UDP port WireGuard listens on (keep in sync with the app UI)."
}

variable "allowed_wg_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
  description = "CIDRs allowed to reach UDP wireguard_port."
}

variable "admin_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH to the server."
}

variable "user_data" {
  type        = string
  default     = null
  description = "Optional cloud-init/user-data."
}

variable "ui_public" {
  type        = bool
  default     = false
  description = "If true, allow 443 from anywhere; if false, restrict to admin_cidrs."
}
