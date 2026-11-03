variable "name_prefix" {
  description = "Prefix for database resource names"
  type        = string
}

variable "region" {
  description = "Region for the managed database"
  type        = string
}

variable "db_tier" {
  description = "Database instance tier"
  type        = string
}

variable "db_name" {
  description = "Logical database name"
  type        = string
}

variable "vpc_id" {
  description = "VPC for private IP connectivity"
  type        = string
}

variable "db_subnet_id" {
  description = "Private database subnet id"
  type        = string
}
