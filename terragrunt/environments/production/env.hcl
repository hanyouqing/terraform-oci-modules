locals {
  environment = "production"
  region      = "ap-seoul-1" # ← Change to your home region
  project     = "oci-modules"

  # Availability domain index (0-based). Most always-free tenancies have 1 AD.
  # Override per module if you have multiple ADs.
  ad_index = 0
}
