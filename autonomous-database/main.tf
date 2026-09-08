resource "oci_database_autonomous_database" "this" {
  for_each = toset(nonsensitive(keys(var.databases)))

  compartment_id                                 = var.compartment_id
  db_name                                        = var.databases[each.key].db_name
  display_name                                   = var.databases[each.key].display_name
  admin_password                                 = var.databases[each.key].admin_password
  db_workload                                    = var.databases[each.key].db_workload
  is_free_tier                                   = var.databases[each.key].is_free_tier
  license_model                                  = var.databases[each.key].license_model
  cpu_core_count                                 = var.databases[each.key].cpu_core_count
  data_storage_size_in_tbs                       = var.databases[each.key].data_storage_size_in_tbs
  is_auto_scaling_enabled                        = var.databases[each.key].is_auto_scaling_enabled
  is_dedicated                                   = var.databases[each.key].is_dedicated
  is_mtls_connection_required                    = var.databases[each.key].is_mtls_connection_required
  is_preview_version_with_service_terms_accepted = var.databases[each.key].is_preview_version_with_service_terms_accepted
  nsg_ids                                        = length(var.databases[each.key].nsg_ids) > 0 ? var.databases[each.key].nsg_ids : null
  private_endpoint_label                         = var.databases[each.key].private_endpoint_label
  subnet_id                                      = var.databases[each.key].subnet_id
  whitelisted_ips                                = length(var.databases[each.key].whitelisted_ips) > 0 ? var.databases[each.key].whitelisted_ips : null

  freeform_tags = merge(
    {
      "ManagedBy"  = "terraform"
      "Module"     = "github.com/hanyouqing/terraform-oci-modules/autonomous-database"
      "AlwaysFree" = tostring(var.databases[each.key].is_free_tier)
    },
    var.freeform_tags,
    var.databases[each.key].freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    var.databases[each.key].defined_tags
  )

  lifecycle {
    precondition {
      condition     = var.allow_world_open_access || !contains(var.databases[each.key].whitelisted_ips, "0.0.0.0/0")
      error_message = "whitelisted_ips must not include 0.0.0.0/0 unless allow_world_open_access=true."
    }

    precondition {
      condition = (
        var.allow_world_open_access
        || var.databases[each.key].subnet_id != null
        || length(var.databases[each.key].whitelisted_ips) > 0
      )
      error_message = "Public Autonomous Database requires non-empty whitelisted_ips, or set subnet_id for a private endpoint (paid tier), or allow_world_open_access=true for labs only."
    }

    precondition {
      condition = (
        !var.databases[each.key].is_free_tier
        || (var.databases[each.key].subnet_id == null && var.databases[each.key].private_endpoint_label == null)
      )
      error_message = "Always Free Autonomous Database cannot use private endpoints; set subnet_id and private_endpoint_label to null and use whitelisted_ips."
    }
  }
}
