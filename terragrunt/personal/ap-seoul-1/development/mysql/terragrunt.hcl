include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/mysql.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vcn" {
  config_path = "../vcn"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    private_subnet_ids = { "private-1" = "ocid1.subnet.oc1..mock" }
  }
}

inputs = {
  mysql_systems = {
    dev-mysql = {
      display_name            = "oci-modules-development-mysql"
      availability_domain     = get_env("TF_VAR_availability_domain", "")
      shape_name              = "MySQL.Free"
      subnet_id               = dependency.vcn.outputs.private_subnet_ids["private-1"]
      admin_username          = "admin"
      admin_password          = get_env("TF_VAR_mysql_admin_password", "")
      mysql_version           = "8.0.35"
      configuration_id        = null
      data_storage_size_in_gb = 50
      backup_policy = {
        is_enabled        = true
        retention_in_days = 7
        window_start_time = "02:00"
      }
    }
  }
}
