include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/autonomous-database.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  databases = {
    adb-prod = {
      db_name                                        = "proddb"
      display_name                                   = "oci-modules-production-adb"
      admin_password                                 = get_env("TF_VAR_adb_admin_password", "")
      db_workload                                    = "OLTP"
      is_free_tier                                   = true
      license_model                                  = "LICENSE_INCLUDED"
      cpu_core_count                                 = 1
      data_storage_size_in_tbs                       = 1
      is_auto_scaling_enabled                        = false
      is_dedicated                                   = false
      is_mtls_connection_required                    = true
      is_preview_version_with_service_terms_accepted = false
      nsg_ids                                        = []
      private_endpoint_label                         = null
      subnet_id                                      = null
      whitelisted_ips                                = ["0.0.0.0/0"]
    }
  }
}
