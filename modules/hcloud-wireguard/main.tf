terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.48.0"
    }
  }
}

# Hetzner Cloud Firewall for WG + UI
resource "hcloud_firewall" "wg" {
  name = var.firewall_name

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.admin_cidrs
    description = "SSH"
  }

  rule {
    direction   = "in"
    protocol    = "udp"
    port        = var.wireguard_port
    source_ips  = var.allowed_wg_cidrs
    description = "WireGuard UDP"
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "HTTP (ACME)"
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = var.ui_public ? ["0.0.0.0/0", "::/0"] : var.admin_cidrs
    description = "WireGuard UI"
  }
}

# Optional SSH keys via selector
data "hcloud_ssh_keys" "selected" {
  with_selector = var.ssh_keys_selector == null ? null : var.ssh_keys_selector
}

# WireGuard server from Marketplace image
resource "hcloud_server" "wg" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.location
  image       = "wireguard"

  ssh_keys = length(var.ssh_key_names) > 0 ? var.ssh_key_names : (
    var.ssh_keys_selector == null ? [] : data.hcloud_ssh_keys.selected.ssh_keys[*].name
  )

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  firewall_ids = [hcloud_firewall.wg.id]

  user_data = var.user_data
}
