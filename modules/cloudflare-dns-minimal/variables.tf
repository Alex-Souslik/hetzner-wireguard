variable "zone_id" { type = string }
variable "hostname" { type = string }

variable "ipv4" {
  type    = string
  default = null
}

variable "ipv6" {
  type    = string
  default = null
}

variable "enable_ipv4" {
  type    = bool
  default = true
}

variable "enable_ipv6" {
  type    = bool
  default = true
}

variable "ttl" {
  type    = number
  default = 120
}
variable "proxied" {
  type        = bool
  default     = false
  description = "Leave false for VPN; Cloudflare cannot proxy UDP."
}
