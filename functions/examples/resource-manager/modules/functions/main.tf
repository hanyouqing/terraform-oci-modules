resource "oci_functions_application" "this" {
  compartment_id             = var.compartment_id
  display_name               = var.display_name
  subnet_ids                 = var.subnet_ids
  shape                      = var.shape
  network_security_group_ids = var.nsg_ids
  config                     = var.application_config
  syslog_url                 = var.syslog_url

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_functions_function" "this" {
  for_each = var.functions

  application_id     = oci_functions_application.this.id
  display_name       = each.key
  memory_in_mbs      = each.value.memory_in_mbs
  timeout_in_seconds = each.value.timeout_in_seconds
  config             = each.value.config

  source_details {
    source_type  = "CONTAINER_IMAGE"
    image        = each.value.image
    image_digest = each.value.image_digest
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/functions"
    Project     = var.project
    Environment = var.environment
  }
}
