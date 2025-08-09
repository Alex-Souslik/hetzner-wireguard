# Random hostname (stable until you rotate it)
resource "random_string" "hostname" {
  count   = var.use_random_hostname ? 1 : 0
  length  = 8
  lower   = true
  upper   = false
  numeric = true
  special = false
}

# Get your current public IPv4/IPv6 at plan/apply time
data "http" "myip4" { url = "https://ipv4.icanhazip.com" }
data "http" "myip6" { url = "https://ipv6.icanhazip.com" }

locals {
  hostname_effective = var.use_random_hostname ? (
    var.random_hostname_prefix == null
    ? random_string.hostname[0].result
    : "${var.random_hostname_prefix}-${random_string.hostname[0].result}"
  ) : var.dns_hostname

  my_ipv4 = trimspace(try(data.http.myip4.response_body, ""))
  my_ipv6 = trimspace(try(data.http.myip6.response_body, ""))

  current_admin = compact([
    length(local.my_ipv4) > 0 ? "${local.my_ipv4}/32" : null,
    length(local.my_ipv6) > 0 ? "${local.my_ipv6}/128" : null,
  ])

  admin_cidrs_effective = var.lock_admin_to_current_ip && length(local.current_admin) > 0 ? local.current_admin : var.hcloud_admin_cidrs

  wg_cidrs_effective = var.lock_wg_to_current_ip && length(local.current_admin) > 0 ? local.current_admin : var.hcloud_allowed_wg_cidrs
}

# Hetzner WireGuard VM
module "wg" {
  source = "./modules/hcloud-wireguard"

  # Core
  hcloud_token = var.hcloud_token
  server_name  = var.hcloud_server_name
  server_type  = var.hcloud_server_type
  location     = var.hcloud_location

  # Access
  wireguard_port   = var.wireguard_port
  admin_cidrs      = local.admin_cidrs_effective
  allowed_wg_cidrs = local.wg_cidrs_effective

  # Cloud-init: minimal hardening + open ufw to match firewall + UI ports
  user_data = <<-CLOUD
  #cloud-config
  package_update: true
  package_upgrade: true
  packages:
    - fail2ban
    - unattended-upgrades

  write_files:
    - path: /etc/ssh/sshd_config.d/10-hardening.conf
      content: |
        PasswordAuthentication no
        PermitRootLogin prohibit-password

  runcmd:
    - sed -i 's/^IPV6=.*/IPV6=yes/' /etc/default/ufw || true
    - systemctl restart ssh
    - apt-get -y install ufw || true
    - ufw allow 22/tcp
    - ufw allow ${var.wireguard_port}/udp
    - ufw allow 80/tcp
    - ufw allow 443/tcp
    - ufw --force enable
CLOUD
}

# Cloudflare DNS (unproxied A/AAAA)
module "dns" {
  source   = "./modules/cloudflare-dns-minimal"
  zone_id  = var.cloudflare_zone_id
  hostname = local.hostname_effective
  ipv4     = module.wg.server_ipv4
  ipv6     = module.wg.server_ipv6
  proxied  = false
  ttl      = 120
}
