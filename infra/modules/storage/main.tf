# Storage layer: Cloud Storage bucket for CloudNotes static/assets objects.

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "null_resource" "assets_bucket" {
  triggers = {
    name       = "${var.name_prefix}-assets-${random_id.bucket_suffix.hex}"
    location   = var.location
    versioning = "enabled"
    resource   = "storage_bucket"
  }
}

resource "null_resource" "assets_bucket_lifecycle" {
  triggers = {
    bucket   = null_resource.assets_bucket.id
    rule     = "nearline-after-30-days"
    resource = "storage_bucket_lifecycle"
  }
}
