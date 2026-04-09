#!/bin/bash
# Copy to account.env.sh and fill in real values. Do not commit account.env.sh (gitignored).
# Usage: source terragrunt/personal/account.env.sh

export OCI_CLI_RC_FILE=

export TF_VAR_account_name="REPLACE_ME"
export OCI_CLI_CONFIG_FILE="$HOME/.oci/${TF_VAR_account_name}/config"
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..REPLACE_ME"
export TF_VAR_compartment_id="ocid1.compartment.oc1..REPLACE_ME"

# Object Storage namespace: output of `oci os ns get --query data --raw-output` — not your username.
# Omit TF_VAR_namespace (or use REPLACE_ME in account.hcl) so terragrunt/root.hcl can run `oci os ns get`.
export TF_VAR_namespace="REPLACE_ME"
export TF_VAR_config_file_profile="DEFAULT"

# Remote state uses Terraform backend "oci" (same API key as the provider). root.hcl sets OCI_CLI_CONFIG_FILE
# to ~/.oci/<account>/config when TF_VAR_account_name is set.
