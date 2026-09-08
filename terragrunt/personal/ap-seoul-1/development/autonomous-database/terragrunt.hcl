include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/autonomous-database.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  adb_cidr = trimspace(get_env("TF_VAR_adb_allowed_cidr", ""))
  allow_world = get_env("TF_VAR_adb_allow_world_open", "false") == "true"
}

inputs = {
  # Development may open wider access only when TF_VAR_adb_allow_world_open=true.
  # Otherwise set TF_VAR_adb_allowed_cidr (required for public endpoint).
  allow_world_open_access = local.allow_world

  databases = {
    adb-dev = {
      db_name                                        = "devdb"
      display_name                                   = "oci-modules-development-adb"
      admin_password                                 = get_env("TF_VAR_adb_admin_password", "")
      db_workload                                    = "OLTP"
      is_free_tier                                   = true
      license_model                                  = "LICENSE_INCLUDED"
      cpu_core_count                                 = 1
      data_storage_size_in_tbs                       = 1
      is_auto_scaling_enabled                        = false
      is_dedicated                                   = false
      is_mtls_connection_required                    = false
      is_preview_version_with_service_terms_accepted = false
      nsg_ids                                        = []
      private_endpoint_label                         = null
      subnet_id                                      = null
      whitelisted_ips = (
        local.allow_world ? ["0.0.0.0/0"] :
        (local.adb_cidr != "" ? [local.adb_cidr] : [])
      )
    }
  }
}
