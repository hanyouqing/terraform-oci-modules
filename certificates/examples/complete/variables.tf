variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "kms_key_id" {
  type        = string
  description = "OCID of the KMS key for CA protection"
}

variable "root_ca_id" {
  type        = string
  description = "OCID of an existing root CA for the subordinate CA (use the root-ca output from a prior apply, or an external CA)"
}

variable "organization" {
  type        = string
  description = "Organization name for certificate subjects"
  default     = "My Organization"
}

variable "country" {
  type        = string
  description = "Country code for certificate subjects"
  default     = "US"
}

variable "web_server_cn" {
  type        = string
  description = "Common name / domain for the web server certificate"
  default     = "app.example.com"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "production"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default     = {}
}

variable "defined_tags" {
  type        = map(map(string))
  description = "Defined tags"
  default     = {}
}
