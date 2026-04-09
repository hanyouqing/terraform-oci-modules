# Root config — loaded by all child units via find_in_parent_folders("root.hcl")
#
# Directory hierarchy: <account>/<region>/<environment>/<module>/terragrunt.hcl
# Three config layers resolved via find_in_parent_folders():
#   account.hcl  → tenancy identity, namespace, OCI CLI profile
#   region.hcl   → OCI region
#   env.hcl      → environment name, project name

locals {
  # ── 3-layer config ──────────────────────────────────────────────────────────
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Account
  account_name        = local.account_vars.locals.account_name
  tenancy_ocid        = local.account_vars.locals.tenancy_ocid
  compartment_id      = local.account_vars.locals.compartment_id
  config_file_profile = try(local.account_vars.locals.config_file_profile, "DEFAULT")

  # From account.hcl namespace / TF_VAR_namespace, or `oci os ns get` (see account.hcl).
  oci_namespace_raw = trimspace(local.account_vars.locals.namespace)
  oci_namespace = (
    length(local.oci_namespace_raw) > 0 &&
    lower(local.oci_namespace_raw) != "replace_me" &&
    local.oci_namespace_raw != "REPLACE_ME"
  ) ? local.oci_namespace_raw : trimspace(run_cmd(
    "oci",
    "--profile",
    local.config_file_profile,
    "os",
    "ns",
    "get",
    "--query",
    "data",
    "--raw-output",
  ))

  # Region
  region = local.region_vars.locals.region

  # Environment
  env     = local.env_vars.locals.environment
  project = local.env_vars.locals.project

  # Remote state bucket (Object Storage). Same formula as object-storage stack: terraform-${env.hcl project}-tfstate
  state_bucket = "${local.project}-tfstate"

  # Same OCI API key file as the Terraform oci provider (backend "oci" reads ~/.oci/config by default).
  # Override with OCI_CLI_CONFIG_FILE. Per-account layout ~/.oci/<account>/config when account_name is set;
  # if account_name is still the placeholder, fall back to ~/.oci/config (e.g. GitHub Actions).
  oci_cli_config_file = length(trimspace(get_env("OCI_CLI_CONFIG_FILE", ""))) > 0 ? trimspace(get_env("OCI_CLI_CONFIG_FILE", "")) : (
    lower(trimspace(local.account_name)) != "replace_me"
    ? pathexpand("~/.oci/${local.account_name}/config")
    : pathexpand("~/.oci/config")
  )
}

# ── Remote State ──────────────────────────────────────────────────────────────
# Terraform native OCI backend (Object Storage). Requires Terraform >= 1.12 (modules use >= 1.14.2).
# See: https://developer.hashicorp.com/terraform/language/backend/oci
#      https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm
#
# Prerequisites:
#   • Object Storage namespace — set in account.hcl / TF_VAR_namespace, or TG_OCI_NAMESPACE in CI, or
#     root.hcl runs `oci --profile <config_file_profile> os ns get` (needs oci on PATH).
#   • OCI API key — same ~/.oci/config profile as the provider (config_file_profile in account.hcl).
#     extra_arguments set OCI_CLI_CONFIG_FILE so backend and provider share one config file.
#   • Create the state bucket once (Console or oci os bucket create). Name: <project>-<account>-tfstate
#     (see local.state_bucket). Object Storage permissions: OBJECT_* on that bucket (Oracle doc above).
#
# Modules with dependency { } blocks resolve outputs via each dependency's backend; all use this backend.
#
# State key layout: <region>/<environment>/<module>/terraform.tfstate
remote_state {
  backend = "oci"

  # Do not set disable_init = true: older Terragrunt passed -backend=false to terraform init,
  # so the backend was never initialized and terraform output failed on dependencies.

  # When false (default), Terragrunt uses a fast path that only reads remote_state and
  # runs terraform output on dependencies — mock_outputs for plan/validate are not applied.
  disable_dependency_optimization = true

  config = {
    bucket              = local.state_bucket
    namespace           = local.oci_namespace
    key                 = "${local.region}/${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region              = local.region
    config_file_profile = local.config_file_profile
    auth                = "APIKey"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Re-run init against the generated backend when backend.tf or state config changes (avoids
# "Backend initialization required" after cache churn or remote_state edits).
terraform {
  extra_arguments "init_reconfigure" {
    commands  = ["init"]
    arguments = ["-reconfigure"]
  }

  extra_arguments "oci_backend_and_provider_config" {
    commands = [
      "apply",
      "console",
      "destroy",
      "import",
      "init",
      "output",
      "plan",
      "providers",
      "refresh",
      "show",
      "state",
      "taint",
      "validate",
      "version",
    ]
    env_vars = {
      OCI_CLI_CONFIG_FILE = local.oci_cli_config_file
    }
  }
}

# ── Provider Generation ────────────────────────────────────────────────────────
# Generates provider_tg.tf with region and config_file_profile from account.hcl.
# Provider version constraints stay in each module's versions.tf.
#
# Authentication:
#   Each account.hcl defines a config_file_profile (e.g., "DEFAULT", "personal", "company").
#   These profiles must exist in ~/.oci/config.
#   Alternatively, set OCI_CLI_* env vars (profile is ignored when env vars are set).
generate "provider" {
  path      = "provider_tg.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
    # Generated by Terragrunt — do not edit manually.
    # Provider version constraints live in the module's versions.tf.
    provider "oci" {
      region              = "${local.region}"
      config_file_profile = "${local.config_file_profile}"
    }
  EOT
}

# ── Shared inputs ─────────────────────────────────────────────────────────────
# Merged (deep) with _envcommon/*.hcl and per-environment terragrunt.hcl.
inputs = {
  project        = local.project
  environment    = local.env
  compartment_id = local.compartment_id
  tenancy_ocid   = local.tenancy_ocid
  freeform_tags = {
    Project     = local.project
    Environment = local.env
    Account     = local.account_name
    Region      = local.region
    ManagedBy   = "terraform"
  }
}
