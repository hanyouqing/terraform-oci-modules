resource "oci_data_safe_data_safe_configuration" "this" {
  compartment_id = var.tenancy_ocid
  is_enabled     = var.is_enabled
}

resource "oci_data_safe_data_safe_private_endpoint" "this" {
  count = var.private_endpoint == null ? 0 : 1

  compartment_id = var.compartment_id
  display_name   = var.private_endpoint.display_name
  subnet_id      = var.private_endpoint.subnet_id
  vcn_id         = var.private_endpoint.vcn_id
  nsg_ids        = var.private_endpoint.nsg_ids

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags

  depends_on = [oci_data_safe_data_safe_configuration.this]
}

resource "oci_data_safe_target_database" "this" {
  for_each = var.target_databases

  compartment_id = var.compartment_id
  display_name   = each.key

  connection_option {
    connection_type              = "PRIVATE_ENDPOINT"
    datasafe_private_endpoint_id = oci_data_safe_data_safe_private_endpoint.this[0].id
  }

  credentials {
    user_name = each.value.user_name
    password  = var.target_database_passwords[each.key]
  }

  database_details {
    database_type          = "AUTONOMOUS_DATABASE"
    infrastructure_type    = "ORACLE_CLOUD"
    autonomous_database_id = each.value.autonomous_database_id
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/data-safe"
    Project     = var.project
    Environment = var.environment
  }
}
