output "app_sa_email" {
  description = "Email of the CloudNotes app service account"
  value       = "${var.name_prefix}-app-sa@${var.project_name}.iam.gserviceaccount.com"
}

output "app_sa_id" {
  description = "Service account resource id"
  value       = null_resource.app_service_account.id
}
