# Root composition: CloudNotes five layers wired via module outputs → inputs.
# Network → Compute / Database; IAM → Compute; Storage stands alone with shared naming.

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source = "./modules/network"

  name_prefix          = local.name_prefix
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  web_subnet_cidr      = var.web_subnet_cidr
  app_subnet_cidr      = var.app_subnet_cidr
  db_subnet_cidr       = var.db_subnet_cidr
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

module "iam" {
  source = "./modules/iam"

  name_prefix  = local.name_prefix
  project_name = var.project_name
  bucket_name  = module.storage.bucket_name
}

module "storage" {
  source = "./modules/storage"

  name_prefix = local.name_prefix
  location    = var.storage_location
}

module "database" {
  source = "./modules/database"

  name_prefix   = local.name_prefix
  region        = var.region
  db_tier       = var.db_tier
  db_name       = var.db_name
  vpc_id        = module.network.vpc_id
  db_subnet_id  = module.network.db_subnet_id
}

module "compute" {
  source = "./modules/compute"

  name_prefix     = local.name_prefix
  region          = var.region
  machine_type    = var.app_machine_type
  app_subnet_id   = module.network.app_subnet_id
  vpc_id          = module.network.vpc_id
  sa_email        = module.iam.app_sa_email
  bucket_name     = module.storage.bucket_name
  db_connection   = module.database.connection_name
}
