variable "name_prefix" {
  description = "Prefix for compute resource names"
  type        = string
}

variable "region" {
  description = "Region for the app instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the CloudNotes app"
  type        = string
}

variable "app_subnet_id" {
  description = "Subnet id where the app instance is placed"
  type        = string
}

variable "vpc_id" {
  description = "VPC id for the instance network interface"
  type        = string
}

variable "sa_email" {
  description = "Service account email attached to the instance"
  type        = string
}

variable "bucket_name" {
  description = "Assets bucket the app reads/writes"
  type        = string
}

variable "db_connection" {
  description = "Database connection name injected into the app"
  type        = string
}
