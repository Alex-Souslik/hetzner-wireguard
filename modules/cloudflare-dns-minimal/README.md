# cloudflare-dns-minimal

Creates unproxied A/AAAA records for `hostname.zone_name` in Cloudflare.

Inputs:
- `zone_id`, `zone_name` (from `data.cloudflare_zone`)
- `hostname` (e.g., `vpn`)
- `ipv4`, `ipv6` (addresses)
- `proxied` (keep `false` for WireGuard)
- `ttl` (default 120)

Output:
- `fqdn`
