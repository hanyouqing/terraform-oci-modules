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

module "notifications" {
  source = "../../"

  compartment_id = var.compartment_id

  topics = {
    alerts = {
      name        = "always-free-alerts"
      description = "Always Free alert notifications"
    }
  }

  subscriptions = {
    email-subscription = {
      topic_key = "alerts"
      protocol  = "EMAIL"
      endpoint  = var.email_endpoint
    }
  }

  project     = "always-free"
  environment = "development"
}
