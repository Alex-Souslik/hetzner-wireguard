output "wg_ipv4" { value = module.wg.server_ipv4 }
output "wg_ipv6" { value = module.wg.server_ipv6 }
output "wg_fqdn" { value = module.dns.fqdn }
