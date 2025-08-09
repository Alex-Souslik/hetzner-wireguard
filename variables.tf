variable "lock_admin_to_current_ip" {
  type    = bool
  default = true
}

variable "lock_wg_to_current_ip" {
  type    = bool
  default = true
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "hcloud_server_name" {
  type    = string
  default = "wg-01"
}

variable "hcloud_server_type" {
  type    = string
  default = "cpx11" # Change to cpx21 for more resources

}

variable "hcloud_location" {
  type    = string
  default = "ash" # US-East (Ashburn)
}

variable "hcloud_admin_cidrs" {
  type    = list(string)
  default = null
}

variable "hcloud_allowed_wg_cidrs" {
  type    = list(string)
  default = null
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

# Your Cloudflare zone ID
variable "cloudflare_zone_id" {
  type = string
}

# WireGuard UDP port
variable "wireguard_port" {
  type    = string
  default = "51820"
  validation {
    condition     = can(tonumber(var.wireguard_port)) && tonumber(var.wireguard_port) >= 1 && tonumber(var.wireguard_port) <= 65535
    error_message = "wireguard_port must be an integer between 1 and 65535."
  }
}

variable "dns_hostname" {
  type    = string
  default = "vpn"
  validation {
    condition     = length(var.dns_hostname) > 0 && can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", var.dns_hostname))
    error_message = "dns_hostname must be a valid DNS label."
  }
}

variable "use_random_hostname" {
  type        = bool
  default     = true
  description = "If true, generate a random hostname instead of using dns_hostname."
}

variable "random_hostname_prefix" {
  type        = string
  default     = null
  description = "Optional prefix for random hostname (e.g., 'ash'); final host like 'ash-<random>'."
}
