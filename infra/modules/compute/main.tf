# Compute layer: CloudNotes application instance in the private app subnet.
# Attaches the IAM service account and receives DB + bucket wiring from root.

resource "random_id" "instance_suffix" {
  byte_length = 2
}

resource "null_resource" "app_instance" {
  triggers = {
    name          = "${var.name_prefix}-app-${random_id.instance_suffix.hex}"
    region        = var.region
    machine_type  = var.machine_type
    subnet_id     = var.app_subnet_id
    vpc_id        = var.vpc_id
    sa_email      = var.sa_email
    bucket_name   = var.bucket_name
    db_connection = var.db_connection
    resource      = "compute_instance"
  }
}

resource "null_resource" "app_disk" {
  triggers = {
    name       = "${var.name_prefix}-app-boot"
    instance   = null_resource.app_instance.id
    size_gb    = "20"
    resource   = "persistent_disk"
  }
}
