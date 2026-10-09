terraform {
  required_version = ">= 1.16.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.9"
    }
  }
}

provider "oci" {}

# Basic example: create a single auth token for a user
module "credentials" {
  source = "../../"

  user_id = var.user_id

  auth_tokens = {
    cicd = {
      description = "Auth token for CI/CD pipeline"
    }
  }

  project     = var.project
  environment = var.environment
}
