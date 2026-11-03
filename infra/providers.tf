# Zero-cost local validation: null + random providers only.
# No cloud credentials, LocalStack daemon, or paid APIs required.
# terraform init / validate / plan work offline; do NOT apply for this capstone.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "null" {}

provider "random" {}
