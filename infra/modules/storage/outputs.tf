output "bucket_name" {
  description = "Globally unique assets bucket name"
  value       = "${var.name_prefix}-assets-${random_id.bucket_suffix.hex}"
}

output "bucket_id" {
  description = "Bucket resource id"
  value       = null_resource.assets_bucket.id
}
