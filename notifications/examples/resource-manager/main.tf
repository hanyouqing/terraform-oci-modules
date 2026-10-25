module "notifications" {
  source = "./modules/notifications"

  compartment_id = var.compartment_ocid

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
