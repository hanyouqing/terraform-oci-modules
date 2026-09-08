variable "compartment_id" {
  type        = string
  description = "OCID of the compartment"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy"
}

variable "vcn_display_name" {
  type        = string
  description = "Display name for the edge VCN"
  default     = "edge-public-vcn"
}

variable "vcn_cidr_blocks" {
  type        = list(string)
  description = "VCN CIDR blocks"
  default     = ["10.10.0.0/16"]
}

variable "vcn_dns_label" {
  type        = string
  description = "DNS label for the VCN"
  default     = "edgepub"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the single public subnet"
  default     = "10.10.1.0/24"
}

variable "ssh_allow_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH (empty = no SSH ingress rule)"
  default     = []
}

variable "create_edge_nsg" {
  type        = bool
  description = "Also create an NSG with HTTPS ingress for attachment to compute"
  default     = true
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "oci-modules"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "development"
}
