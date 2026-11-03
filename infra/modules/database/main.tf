# Database layer: managed CloudNotes DB on the private db subnet / VPC.

resource "random_id" "db_suffix" {
  byte_length = 2
}

resource "null_resource" "db_instance" {
  triggers = {
    name       = "${var.name_prefix}-sql-${random_id.db_suffix.hex}"
    region     = var.region
    tier       = var.db_tier
    vpc_id     = var.vpc_id
    subnet_id  = var.db_subnet_id
    db_name    = var.db_name
    private_ip = "true"
    resource   = "sql_database_instance"
  }
}

resource "null_resource" "db_database" {
  triggers = {
    name      = var.db_name
    instance  = null_resource.db_instance.id
    resource  = "sql_database"
  }
}
