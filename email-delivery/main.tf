terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

resource "oci_email_sender" "this" {
  for_each = var.senders

  compartment_id = var.compartment_id
  email_address  = each.value.email_address
  is_verified    = false

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/email-delivery"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )
}

resource "oci_email_suppression" "this" {
  for_each = var.suppressions

  compartment_id = var.compartment_id
  email_address  = each.value.email_address

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/email-delivery/suppression"
    }
  )
}
