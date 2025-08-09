# hcloud-wireguard

Creates a Hetzner Cloud VM using Marketplace `wireguard` and opens:
- UDP `${var.wireguard_port}` (default 51820)
- TCP 22/80/443
- ICMP

Default `location = "ash"` (US-East). Switch to `"hil"` for US-West.

This module **does not** manage DNS. Pair it with a DNS module at root.
