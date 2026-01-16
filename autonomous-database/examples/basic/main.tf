terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "autonomous_database" {
  source = "../../"

  compartment_id = var.compartment_id

  databases = {
    adb-1 = {
      db_name                  = "alwaysfreeadb"
      display_name             = "Always Free ADB"
      admin_password           = var.admin_password
      db_workload              = "OLTP"
      is_free_tier             = true
      license_model            = "LICENSE_INCLUDED"
      cpu_core_count           = 1
      data_storage_size_in_tbs = 1
      is_auto_scaling_enabled  = false
      is_dedicated             = false
      is_mtls_connection_required = false
      is_preview_version_with_service_terms_accepted = false
      nsg_ids                  = []
      private_endpoint_label   = null
      subnet_id                = null
      vcn_id                   = null
      whitelisted_ips          = ["0.0.0.0/0"]
      freeform_tags            = {}
      defined_tags             = {}
    }
  }

  project     = "always-free"
  environment = "development"
}
