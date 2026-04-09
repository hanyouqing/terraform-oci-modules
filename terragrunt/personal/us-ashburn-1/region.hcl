# Region-level configuration.
#
# This file is read by root.hcl via find_in_parent_folders("region.hcl").
# All stacks under this directory deploy to this region.

locals {
  region = "us-ashburn-1"
}
