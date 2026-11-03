output "vpc_id" {
  description = "CloudNotes VPC identifier"
  value       = module.network.vpc_id
}

output "app_subnet_id" {
  description = "Private app subnet where the CloudNotes instance runs"
  value       = module.network.app_subnet_id
}

output "app_instance_ip" {
  description = "Private IP of the CloudNotes app instance"
  value       = module.compute.app_instance_ip
}

output "app_instance_name" {
  description = "Name of the CloudNotes app compute instance"
  value       = module.compute.app_instance_name
}

output "bucket_name" {
  description = "Cloud Storage bucket for CloudNotes assets"
  value       = module.storage.bucket_name
}

output "db_name" {
  description = "Managed database name"
  value       = module.database.db_name
}

output "db_connection_name" {
  description = "Database connection name for the app"
  value       = module.database.connection_name
}

output "app_sa_email" {
  description = "Service account email used by the app instance"
  value       = module.iam.app_sa_email
}

output "environment" {
  description = "Deployed environment label"
  value       = var.environment
}
