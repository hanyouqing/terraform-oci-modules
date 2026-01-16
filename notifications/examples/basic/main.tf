terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

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
