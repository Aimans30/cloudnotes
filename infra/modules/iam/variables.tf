variable "name_prefix" {
  description = "Prefix for IAM resource names"
  type        = string
}

variable "project_name" {
  description = "Project name used in role binding descriptions"
  type        = string
}

variable "bucket_name" {
  description = "Assets bucket the app SA may read/write"
  type        = string
}
