include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/block-storage.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "compute" {
  config_path = "../compute"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    instance_ids = ["ocid1.instance.oc1..mock"]
  }
}

inputs = {
  volumes = {
    data-vol-1 = {
      display_name         = "oci-modules-production-data-vol-1"
      availability_domain  = get_env("TF_VAR_availability_domain", "")
      size_in_gbs          = 50
      vpus_per_gb          = "10"
      is_auto_tune_enabled = true
      backup_policy_id     = null
      backup_type          = "FULL"
    }
  }

  create_backups = true

  volume_attachments = {
    data-vol-1-attach = {
      attachment_type = "paravirtualized"
      instance_id     = dependency.compute.outputs.instance_ids[0]
      volume_key      = "data-vol-1"
      display_name    = "data-vol-1-attachment"
      device          = "/dev/oracleoci/oraclevdb"
      is_read_only    = false
      is_shareable    = false
    }
  }
}
