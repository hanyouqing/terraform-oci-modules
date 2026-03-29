# Environment-level configuration for us-ashburn-1 development.
#
# This demonstrates deploying the same project to a second region.
# Account identity is inherited from parent account.hcl.

locals {
  environment = "development"
  project     = "oci-modules"

  # Availability domain index (0-based).
  # us-ashburn-1 has 3 ADs — change to 1 or 2 if spreading across ADs.
  ad_index = 0
}
