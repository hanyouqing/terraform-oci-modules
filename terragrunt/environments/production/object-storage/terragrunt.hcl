include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders())}/_envcommon/object-storage.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  buckets = {
    app-bucket = {
      name         = "oci-modules-production-app-bucket"
      namespace    = null
      access_type  = "NoPublicAccess"
      storage_tier = "Standard"
      versioning   = "Enabled"
    }
    logs-bucket = {
      name         = "oci-modules-production-logs-bucket"
      namespace    = null
      access_type  = "NoPublicAccess"
      storage_tier = "Standard"
      versioning   = "Enabled"
    }
  }
}
