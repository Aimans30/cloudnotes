# IAM layer: least-privilege service account for the CloudNotes app.
# Bindings: objectAdmin on the assets bucket + client role for Cloud SQL.

resource "null_resource" "app_service_account" {
  triggers = {
    account_id   = "${var.name_prefix}-app-sa"
    display_name = "CloudNotes App Service Account"
    email        = "${var.name_prefix}-app-sa@${var.project_name}.iam.gserviceaccount.com"
    resource     = "service_account"
  }
}

resource "null_resource" "sa_bucket_binding" {
  triggers = {
    sa       = null_resource.app_service_account.id
    role     = "roles/storage.objectAdmin"
    bucket   = var.bucket_name
    resource = "iam_member"
  }
}

resource "null_resource" "sa_sql_binding" {
  triggers = {
    sa       = null_resource.app_service_account.id
    role     = "roles/cloudsql.client"
    project  = var.project_name
    resource = "iam_member"
  }
}

resource "null_resource" "sa_logging_binding" {
  triggers = {
    sa       = null_resource.app_service_account.id
    role     = "roles/logging.logWriter"
    project  = var.project_name
    resource = "iam_member"
  }
}
