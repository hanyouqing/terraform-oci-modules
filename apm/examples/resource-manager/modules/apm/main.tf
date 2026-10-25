# --- APM Domains ---

resource "oci_apm_apm_domain" "this" {
  for_each = var.apm_domains

  compartment_id = var.compartment_id
  display_name   = each.value.display_name
  description    = each.value.description
  is_free_tier   = each.value.is_free_tier

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/apm"
      "Project"     = var.project
      "Environment" = var.environment
      "AlwaysFree"  = tostring(each.value.is_free_tier)
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

# --- Synthetics Monitors ---

resource "oci_apm_synthetics_monitor" "this" {
  for_each = var.synthetics_monitors

  apm_domain_id              = each.value.apm_domain_key != null ? oci_apm_apm_domain.this[each.value.apm_domain_key].id : each.value.apm_domain_id
  display_name               = each.value.display_name
  monitor_type               = each.value.monitor_type
  repeat_interval_in_seconds = each.value.repeat_interval_in_seconds
  target                     = each.value.target
  status                     = each.value.status
  is_run_once                = each.value.is_run_once
  scheduling_policy          = each.value.scheduling_policy
  is_run_now                 = each.value.is_run_now
  script_id                  = each.value.script_id
  timeout_in_seconds         = each.value.timeout_in_seconds
  batch_interval_in_seconds  = each.value.batch_interval_in_seconds

  configuration {
    config_type                       = each.value.config_type
    is_failure_retried                = each.value.is_failure_retried
    is_certificate_validation_enabled = each.value.is_certificate_validation_enabled
    is_redirection_enabled            = each.value.is_redirection_enabled
    request_method                    = each.value.request_method
    verify_response_content           = each.value.verify_response_content
    verify_response_codes             = each.value.verify_response_codes
  }

  dynamic "script_parameters" {
    for_each = each.value.script_parameters
    content {
      param_name  = script_parameters.value.param_name
      param_value = script_parameters.value.param_value
    }
  }

  dynamic "vantage_points" {
    for_each = each.value.vantage_points
    content {
      name = vantage_points.value
    }
  }

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/apm"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags,
    each.value.freeform_tags
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}
