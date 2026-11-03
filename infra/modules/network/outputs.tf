output "vpc_id" {
  description = "VPC identifier"
  value       = "${var.name_prefix}-vpc-${null_resource.vpc.id}"
}

output "web_subnet_id" {
  description = "Web tier subnet id"
  value       = "${var.name_prefix}-web-${null_resource.subnet_web.id}"
}

output "app_subnet_id" {
  description = "App tier subnet id"
  value       = "${var.name_prefix}-app-${null_resource.subnet_app.id}"
}

output "db_subnet_id" {
  description = "Database tier subnet id"
  value       = "${var.name_prefix}-db-${null_resource.subnet_db.id}"
}

output "firewall_web_id" {
  description = "Web ingress firewall id"
  value       = null_resource.firewall_web.id
}
