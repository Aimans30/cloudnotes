output "db_instance_name" {
  description = "Managed database instance name"
  value       = "${var.name_prefix}-sql-${random_id.db_suffix.hex}"
}

output "db_name" {
  description = "Logical database name"
  value       = var.db_name
}

output "connection_name" {
  description = "Connection string/name the app uses to reach the DB"
  value       = "${var.name_prefix}:${var.region}:${var.name_prefix}-sql-${random_id.db_suffix.hex}"
}

output "db_instance_id" {
  description = "Database instance resource id"
  value       = null_resource.db_instance.id
}
