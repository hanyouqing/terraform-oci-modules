# Account-level configuration for the "personal" OCI tenancy.
#
# This file is read by the root terragrunt.hcl via find_in_parent_folders("account.hcl").
# All stacks under this directory inherit these values.
#
# To add another account, create a sibling directory (e.g., ../company/) with its own account.hcl.

locals {
  account_name = "personal"

  # OCI tenancy OCID — find in OCI Console → Governance → Tenancy Details
  tenancy_ocid = get_env("TF_VAR_tenancy_ocid", "ocid1.tenancy.oc1..REPLACE_ME")

  # Default compartment for resources — override per env.hcl or per module if needed
  compartment_id = get_env("TF_VAR_compartment_id", "ocid1.compartment.oc1..REPLACE_ME")

  # Object Storage namespace — find via: oci os ns get
  namespace = get_env("TG_OCI_NAMESPACE", "REPLACE_ME")

  # OCI CLI config profile name in ~/.oci/config
  # Use different profiles for different accounts (e.g., "personal", "company")
  config_file_profile = get_env("OCI_CLI_PROFILE", "DEFAULT")
}
