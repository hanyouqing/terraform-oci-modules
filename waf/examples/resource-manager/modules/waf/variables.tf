variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the WAF policy and firewall."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "display_name" {
  type        = string
  description = "Display name of the WAF policy. The firewall uses the same name when a load balancer is set."

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be 1 to 255 characters."
  }
}

variable "load_balancer_id" {
  type        = string
  description = "OCID of the flexible load balancer to protect. Null creates the policy only."
  default     = null

  validation {
    condition     = var.load_balancer_id == null ? true : can(regex("^ocid1\\.loadbalancer\\.oc1\\.", var.load_balancer_id))
    error_message = "load_balancer_id must be a load balancer OCID."
  }
}

variable "protection_capabilities" {
  type = list(object({
    key     = string
    version = number
  }))
  description = "Oracle WAF protection capabilities. key and version must exist for the target region. Empty skips request inspection."
  default     = []

  validation {
    condition = alltrue([
      for capability in var.protection_capabilities :
      can(regex("^[0-9]+$", capability.key)) && capability.version >= 1
    ])
    error_message = "Each protection capability needs a numeric key and a version of at least 1."
  }
}

variable "rate_limit" {
  type = object({
    period_in_seconds = number
    requests_limit    = number
  })
  description = "Optional request rate limit. Matching clients receive HTTP 403. Null skips rate limiting."
  default     = null
}

variable "project" {
  type        = string
  description = "Project name recorded on freeform tags."
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name recorded on freeform tags."
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags merged onto module-managed tags."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags applied to the policy and firewall."
  default     = {}
}

check "firewall_has_a_control" {
  assert {
    condition = var.load_balancer_id == null ? true : (
      length(var.protection_capabilities) > 0 || var.rate_limit != null
    )
    error_message = "Set protection_capabilities or rate_limit before attaching the firewall to a load balancer."
  }
}

check "rate_limit_is_positive" {
  assert {
    condition = var.rate_limit == null ? true : (
      var.rate_limit.period_in_seconds >= 1 && var.rate_limit.requests_limit >= 1
    )
    error_message = "rate_limit.period_in_seconds and rate_limit.requests_limit must be at least 1."
  }
}
