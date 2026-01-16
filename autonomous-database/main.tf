terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

resource "oci_database_autonomous_database" "this" {
  for_each = var.databases

  compartment_id           = var.compartment_id
  db_name                  = each.value.db_name
  display_name             = each.value.display_name
  admin_password           = each.value.admin_password
  db_workload              = each.value.db_workload
  is_free_tier             = each.value.is_free_tier
  license_model            = each.value.license_model
  cpu_core_count           = each.value.cpu_core_count
  data_storage_size_in_tbs = each.value.data_storage_size_in_tbs
  is_auto_scaling_enabled  = each.value.is_auto_scaling_enabled
  is_dedicated             = each.value.is_dedicated
  is_mtls_connection_required = each.value.is_mtls_connection_required
  is_preview_version_with_service_terms_accepted = each.value.is_preview_version_with_service_terms_accepted
  nsg_ids                  = length(each.value.nsg_ids) > 0 ? each.value.nsg_ids : null
  private_endpoint_label   = each.value.private_endpoint_label
  subnet_id                = each.value.subnet_id
  vcn_id                   = each.value.vcn_id
  whitelisted_ips          = length(each.value.whitelisted_ips) > 0 ? each.value.whitelisted_ips : null

  freeform_tags = merge(
    var.freeform_tags,
    each.value.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/autonomous-database"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}
