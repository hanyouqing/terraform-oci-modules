module "email_delivery" {
  source = "./modules/email-delivery"

  compartment_id = var.compartment_ocid

  senders = {
    sender-1 = {
      email_address = var.sender_email
    }
  }

  project     = "always-free"
  environment = "development"
}
