terraform {
  required_version = ">= 1.4.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.40.0"
    }
  }
}

data "cloudflare_zone" "this" {
  zone_id = var.zone_id
}

locals {
  zone_name = data.cloudflare_zone.this.name
}

resource "cloudflare_dns_record" "a" {
  count   = var.enable_ipv4 ? 1 : 0
  zone_id = var.zone_id
  name    = var.hostname
  type    = "A"
  content = var.ipv4
  ttl     = var.ttl
  proxied = var.proxied
}

resource "cloudflare_dns_record" "aaaa" {
  count   = var.enable_ipv6 ? 1 : 0
  zone_id = var.zone_id
  name    = var.hostname
  type    = "AAAA"
  content = var.ipv6
  ttl     = var.ttl
  proxied = var.proxied
}
