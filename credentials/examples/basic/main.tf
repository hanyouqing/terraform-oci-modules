terraform {
  required_version = ">= 1.14.2"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

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
