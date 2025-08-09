# If you use "@" for apex, output the zone itself.
output "fqdn" {
  value       = var.hostname == "@" ? local.zone_name : "${var.hostname}.${local.zone_name}"
  description = "FQDN of the host"
}
