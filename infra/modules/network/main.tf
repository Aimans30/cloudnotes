# Network layer: VPC, three-tier subnets (web/app/db), and ingress firewall.
# Modeled with null_resource for zero-cost local plan/validate.

resource "null_resource" "vpc" {
  triggers = {
    name      = "${var.name_prefix}-vpc"
    cidr      = var.vpc_cidr
    region    = var.region
    resource  = "vpc"
  }
}

resource "null_resource" "subnet_web" {
  triggers = {
    name     = "${var.name_prefix}-web"
    cidr     = var.web_subnet_cidr
    vpc      = null_resource.vpc.id
    tier     = "web"
    resource = "subnet"
  }
}

resource "null_resource" "subnet_app" {
  triggers = {
    name     = "${var.name_prefix}-app"
    cidr     = var.app_subnet_cidr
    vpc      = null_resource.vpc.id
    tier     = "app"
    resource = "subnet"
  }
}

resource "null_resource" "subnet_db" {
  triggers = {
    name     = "${var.name_prefix}-db"
    cidr     = var.db_subnet_cidr
    vpc      = null_resource.vpc.id
    tier     = "db"
    resource = "subnet"
  }
}

resource "null_resource" "firewall_web" {
  triggers = {
    name           = "${var.name_prefix}-allow-web"
    vpc            = null_resource.vpc.id
    ports          = "80,443"
    source_cidrs   = join(",", var.allowed_ingress_cidrs)
    target_subnet  = null_resource.subnet_web.id
    resource       = "firewall"
  }
}

resource "null_resource" "firewall_internal" {
  triggers = {
    name     = "${var.name_prefix}-allow-internal"
    vpc      = null_resource.vpc.id
    cidr     = var.vpc_cidr
    resource = "firewall"
  }
}
