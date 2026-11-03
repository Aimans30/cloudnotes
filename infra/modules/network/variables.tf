variable "name_prefix" {
  description = "Prefix for network resource names"
  type        = string
}

variable "region" {
  description = "Region for regional subnets"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "web_subnet_cidr" {
  description = "Web tier subnet CIDR"
  type        = string
}

variable "app_subnet_cidr" {
  description = "App tier subnet CIDR"
  type        = string
}

variable "db_subnet_cidr" {
  description = "Database tier subnet CIDR"
  type        = string
}

variable "allowed_ingress_cidrs" {
  description = "Source CIDRs allowed through the web firewall"
  type        = list(string)
}
