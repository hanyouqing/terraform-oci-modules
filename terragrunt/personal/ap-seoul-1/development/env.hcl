# Environment-level configuration.
#
# This file is read by root.hcl via find_in_parent_folders("env.hcl").
# Account and region are inherited from parent account.hcl and region.hcl.

locals {
  environment = "development"
  project     = "terraform-oci-modules"

  # Availability domain index (0-based). Most always-free tenancies have 1 AD.
  ad_index = 0
}
