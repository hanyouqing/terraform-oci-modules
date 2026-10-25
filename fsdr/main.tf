resource "oci_disaster_recovery_dr_protection_group" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name

  log_location {
    bucket    = var.log_bucket
    namespace = var.log_namespace
  }

  dynamic "association" {
    for_each = var.association == null ? [] : [var.association]
    content {
      role        = association.value.role
      peer_id     = association.value.peer_id
      peer_region = association.value.peer_region
    }
  }

  dynamic "members" {
    for_each = var.members
    content {
      member_id   = members.value.member_id
      member_type = members.value.member_type
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/fsdr"
    Project     = var.project
    Environment = var.environment
  }
}
