output "app_instance_name" {
  description = "Name of the CloudNotes app instance"
  value       = "${var.name_prefix}-app-${random_id.instance_suffix.hex}"
}

output "app_instance_id" {
  description = "App instance resource id"
  value       = null_resource.app_instance.id
}

output "app_instance_ip" {
  description = "Deterministic placeholder private IP for local plans (app subnet .10)"
  value       = "10.0.2.10"
}
