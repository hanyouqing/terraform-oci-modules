variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "drg_id" {
  type        = string
  description = "OCID of the Dynamic Routing Gateway"
}

variable "primary_cpe_ip" {
  type        = string
  description = "Public IP of the primary site VPN device"
}

variable "dr_cpe_ip" {
  type        = string
  description = "Public IP of the DR site VPN device"
}

variable "primary_on_prem_cidrs" {
  type        = list(string)
  description = "On-premises CIDRs for the primary site"
  default     = ["10.0.0.0/16"]
}

variable "dr_on_prem_cidrs" {
  type        = list(string)
  description = "On-premises CIDRs for the DR site"
  default     = ["172.16.0.0/16"]
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
