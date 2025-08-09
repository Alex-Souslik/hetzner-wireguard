# Hetzner WireGuard VPN with Cloudflare DNS (Terraform)

Terraform configuration to deploy a WireGuard VPN server on Hetzner Cloud with optional Cloudflare DNS records.

Uses:
- [Hetzner WireGuard Marketplace image](https://docs.hetzner.com/cloud/apps/list/wireguard/)
- Hetzner Cloud Firewall for basic network hardening
- Optional Cloudflare DNS A/AAAA records (unproxied — Cloudflare cannot proxy UDP)
- Optional random hostname generation
- Optional IP-based locking for SSH/UI/WireGuard ports

---

## Features

- Deploys in Hetzner Cloud **Ashburn** or **Hillsboro** (US) or any supported Hetzner location.
- Automatically configures Hetzner Cloud Firewall:
  - Locks SSH (22) and UI (443) to admin IPs
  - Locks WireGuard UDP port to allowed peers
  - Leaves HTTP (80) world-open for ACME HTTP-01 challenges
- Cloud-init provisioning:
  - Basic SSH hardening
  - UFW firewall to match Hetzner Cloud Firewall rules
  - Fail2ban and unattended upgrades
- Cloudflare DNS records for IPv4/IPv6, TTL 120s, unproxied.
- Optional:
  - Random subdomain hostname with optional prefix
  - Auto-lock ports to your current IP at `terraform apply` time

---

## Security defaults

- **WireGuard UDP port**: defaults to `51820` (change via `wireguard_port`)
- **SSH/UI access (22/tcp, 443/tcp)**: locked to `admin_cidrs`
  - If `lock_admin_to_current_ip = true`, Terraform auto-detects your current public IP at apply time and uses it instead
- **WireGuard UDP (51820/udp)**: allowed from `allowed_wg_cidrs`
  - If `lock_wg_to_current_ip = true`, Terraform auto-detects your current public IP and only allows that
- **HTTP (80/tcp)**: world-open for ACME HTTP-01 challenges
- **UI** (`ui_public`): false by default (only admin_cidrs allowed on 443)

---

## Variables

### Hostname and domain
- `dns_hostname` — static subdomain label (e.g., `"vpn"`). Ignored if `use_random_hostname = true`.
- `use_random_hostname` — if true (default), generates an 8-char random lowercase+digit hostname.
- `random_hostname_prefix` — optional string prepended to the random hostname (e.g., `"ash"` → `ash-3f92xk1h`).

### IP locking
- `lock_admin_to_current_ip` — if true (default), locks SSH and UI ports to your current IPv4/IPv6 at apply time.
- `lock_wg_to_current_ip` — if true (default), locks WireGuard UDP port to your current IPv4/IPv6 at apply time.
- `hcloud_admin_cidrs` — fallback list for admin ports if `lock_admin_to_current_ip` is false.
- `hcloud_allowed_wg_cidrs` — fallback list for WireGuard UDP if `lock_wg_to_current_ip` is false.
