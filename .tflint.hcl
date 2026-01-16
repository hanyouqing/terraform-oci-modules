# =============================================================================
# TFLint Configuration
# =============================================================================
# 
# TFLint is a Terraform linter that finds errors and possible problems
# in Terraform code before running terraform plan/apply.
#
# Usage:
#   tflint --init
#   tflint
#   tflint --recursive
#
# Documentation: https://github.com/terraform-linters/tflint
# =============================================================================

config {
  # Enable module inspection
  module = true

  # Force required version
  force = false

  # Disable rules by default (set to true to enable all rules)
  disabled_by_default = false

  # Format output
  format = "default"

  # Enable color output
  color = true
}

# =============================================================================
# Plugin Configuration
# =============================================================================

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# OCI Provider Plugin
plugin "oci" {
  enabled = true
  version = "0.1.0"
  source  = "github.com/oracle/tflint-ruleset-oci"
}

# =============================================================================
# Rule Configuration
# =============================================================================

# Terraform rules
rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style   = "flexible" # Options: "semver", "flexible", "none"
}

rule "terraform_module_version" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case" # Options: "snake_case", "none"
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# =============================================================================
# Ignore Rules (Optional)
# =============================================================================

# Uncomment to ignore specific rules
# rule "terraform_documented_outputs" {
#   enabled = false
# }

# =============================================================================
# Ignore Files/Directories
# =============================================================================

# Files and directories to ignore
ignore_module = [
  ".terraform/**",
  "**/.terraform/**",
]
