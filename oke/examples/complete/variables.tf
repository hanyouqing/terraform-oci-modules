
variable "compartment_id" {
  type        = string
  description = "Compartment OCID for the cluster and node pool."
}

variable "name" {
  type        = string
  description = "Cluster name."
  default     = "oke-complete"
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

variable "kms_key_id" {
  type        = string
  description = "Vault key OCID for Kubernetes secret encryption."
  default     = null
}

variable "node_pools" {
  type = map(object({
    node_shape          = string
    size                = number
    availability_domain = string
    subnet_id           = string
    image_id            = string
    ocpus               = number
    memory_in_gbs       = number
    ssh_public_key      = optional(string)
    nsg_ids             = optional(set(string), [])
    pod_subnet_ids      = optional(list(string), [])
  }))
  description = "Worker node pools. Each pool needs pod_subnet_ids for VCN-native CNI."
}

variable "project" {
  type        = string
  description = "Project tag."
  default     = "oke"
}

variable "environment" {
  type        = string
  description = "Environment tag."
  default     = "production"
}
