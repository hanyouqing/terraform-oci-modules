# Account-level configuration for the "personal" OCI tenancy.
#
# This file is read by root.hcl via find_in_parent_folders("account.hcl").
# All stacks under this directory inherit these values.
#
# To add another account, create a sibling directory (e.g., ../company/) with its own account.hcl.

locals {
  account_name = get_env("TF_VAR_account_name", "REPLACE_ME")
  tenancy_ocid = get_env("TF_VAR_tenancy_ocid", "ocid1.tenancy.oc1..REPLACE_ME")
  compartment_id = get_env("TF_VAR_compartment_id", "ocid1.compartment.oc1..REPLACE_ME")
  # Object Storage namespace from `oci os ns get --query data --raw-output` — not your username.
  namespace = get_env("TF_VAR_namespace", "REPLACE_ME")
  config_file_profile = get_env("OCI_CLI_PROFILE", "DEFAULT")
}
