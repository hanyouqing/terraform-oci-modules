resource "oci_waf_web_app_firewall_policy" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name

  actions {
    name = "allow"
    type = "ALLOW"
  }

  actions {
    name = "block"
    type = "RETURN_HTTP_RESPONSE"
    code = 403

    body {
      type = "STATIC_TEXT"
      text = "Forbidden"
    }

    headers {
      name  = "Content-Type"
      value = "text/plain"
    }
  }

  dynamic "request_protection" {
    for_each = length(var.protection_capabilities) == 0 ? [] : [1]

    content {
      rules {
        name        = "inspect"
        type        = "PROTECTION"
        action_name = "block"

        dynamic "protection_capabilities" {
          for_each = var.protection_capabilities

          content {
            key     = protection_capabilities.value.key
            version = protection_capabilities.value.version
          }
        }
      }
    }
  }

  dynamic "request_rate_limiting" {
    for_each = var.rate_limit == null ? [] : [var.rate_limit]

    content {
      rules {
        name        = "rate"
        type        = "REQUEST_RATE_LIMITING"
        action_name = "block"

        configurations {
          period_in_seconds = request_rate_limiting.value.period_in_seconds
          requests_limit    = request_rate_limiting.value.requests_limit
        }
      }
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_waf_web_app_firewall" "this" {
  count = var.load_balancer_id == null ? 0 : 1

  compartment_id             = var.compartment_id
  display_name               = var.display_name
  backend_type               = "LOAD_BALANCER"
  load_balancer_id           = var.load_balancer_id
  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.this.id

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/waf"
    Project     = var.project
    Environment = var.environment
  }
}
