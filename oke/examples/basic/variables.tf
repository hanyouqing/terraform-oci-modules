
variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the cluster."
}

variable "name" {
  type        = string
  description = "Cluster name."
  default     = "oke-basic"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version supported in the region."
}

variable "vcn_id" {
  type        = string
  description = "VCN OCID."
}

variable "endpoint_subnet_id" {
  type        = string
  description = "Private subnet OCID for the API endpoint."
}
