variable "project_name" {
  description = "CloudNotes project name used to prefix resource identifiers"
  type        = string
  default     = "cloudnotes"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Primary region for CloudNotes resources"
  type        = string
  default     = "us-central1"
}

variable "vpc_cidr" {
  description = "CIDR block for the CloudNotes VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_cidr" {
  description = "CIDR for the public web tier subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR for the private app tier subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR for the private database tier subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_machine_type" {
  description = "Machine type for the CloudNotes app compute instance"
  type        = string
  default     = "e2-medium"
}

variable "db_tier" {
  description = "Managed database instance tier"
  type        = string
  default     = "db-f1-micro"
}

variable "db_name" {
  description = "Logical database name for CloudNotes"
  type        = string
  default     = "cloudnotes"
}

variable "storage_location" {
  description = "Location/region for the assets bucket"
  type        = string
  default     = "US"
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the web tier (firewall)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
