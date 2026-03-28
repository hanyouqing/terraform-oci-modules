variable "compartment_id" {
  type        = string
  description = "OCID of the compartment where APM resources will be created"

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id)) || can(regex("^ocid1\\.tenancy\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a valid OCI compartment or tenancy OCID."
  }
}

variable "apm_domains" {
  type = map(object({
    display_name = string
    description  = optional(string, "")
    is_free_tier = optional(bool, true)
    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of APM domains to create. Always Free: 1 domain with 1,000 tracing events/hour."
  default     = {}
}

variable "synthetics_monitors" {
  type = map(object({
    display_name       = string
    monitor_type       = string
    repeat_interval_in_seconds = number

    # Reference to APM domain — either a key in apm_domains or a direct OCID
    apm_domain_key = optional(string, null)
    apm_domain_id  = optional(string, null)

    target  = optional(string, null)
    status  = optional(string, "ENABLED")
    is_run_once = optional(bool, false)

    # Scheduling
    scheduling_policy = optional(string, "ALL")
    is_run_now        = optional(bool, false)

    # Script (for scripted monitors)
    script_id         = optional(string, null)
    script_parameters = optional(list(object({
      param_name  = string
      param_value = string
    })), [])

    # Vantage points
    vantage_points = optional(list(string), [])

    # Timeout and configuration settings
    timeout_in_seconds     = optional(number, 60)
    batch_interval_in_seconds = optional(number, null)

    # Configuration block
    config_type            = optional(string, null)
    is_failure_retried     = optional(bool, true)
    is_certificate_validation_enabled = optional(bool, true)
    is_redirection_enabled = optional(bool, true)
    request_method         = optional(string, null)
    verify_response_content = optional(string, null)
    verify_response_codes  = optional(list(string), null)

    freeform_tags = optional(map(string), {})
    defined_tags  = optional(map(string), {})
  }))
  description = "Map of Synthetics monitors. Always Free: 10 synthetic runs/hour."
  default     = {}

  validation {
    condition = alltrue([
      for m in var.synthetics_monitors : contains([
        "SCRIPTED_BROWSER", "BROWSER", "SCRIPTED_REST", "REST", "NETWORK", "DNS", "FTP"
      ], m.monitor_type)
    ])
    error_message = "monitor_type must be one of: SCRIPTED_BROWSER, BROWSER, SCRIPTED_REST, REST, NETWORK, DNS, FTP."
  }

  validation {
    condition = alltrue([
      for m in var.synthetics_monitors : contains(["ENABLED", "DISABLED", "INVALID"], m.status)
    ])
    error_message = "status must be one of: ENABLED, DISABLED, INVALID."
  }

  validation {
    condition = alltrue([
      for m in var.synthetics_monitors : m.apm_domain_key != null || m.apm_domain_id != null
    ])
    error_message = "Each monitor must have either apm_domain_key (referencing a key in apm_domains) or apm_domain_id (external APM domain OCID)."
  }
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
  default     = "development"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all resources"
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all resources"
  default     = {}
}
