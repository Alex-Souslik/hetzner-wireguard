# Hetzner Cloud
provider "hcloud" {
  token = var.hcloud_token
}

# Cloudflare DNS
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
