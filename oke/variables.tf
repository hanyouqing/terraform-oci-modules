variable "compartment_id" {
  type        = string
  description = "OCID of the compartment that owns the cluster and node pools."

  validation {
    condition     = can(regex("^ocid1\\.compartment\\.oc1\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment OCID."
  }
}

variable "name" {
  type        = string
  description = "Name of the OKE cluster."

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 32
    error_message = "name must be 1 to 32 characters."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version supported in the target region, for example v1.33.1. There is no default, because supported versions change by region."

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+", var.kubernetes_version))
    error_message = "kubernetes_version must look like v1.33.1."
  }
}

variable "vcn_id" {
  type        = string
  description = "OCID of the VCN for the cluster."

  validation {
    condition     = can(regex("^ocid1\\.vcn\\.oc1\\.", var.vcn_id))
    error_message = "vcn_id must be a VCN OCID."
  }
}

variable "endpoint_subnet_id" {
  type        = string
  description = "OCID of the subnet for the Kubernetes API endpoint. Use a private subnet."

  validation {
    condition     = can(regex("^ocid1\\.subnet\\.oc1\\.", var.endpoint_subnet_id))
    error_message = "endpoint_subnet_id must be a subnet OCID."
  }
}

variable "endpoint_public_ip_enabled" {
  type        = bool
  description = "Assign a public IP to the Kubernetes API endpoint. Leave false so the API is reachable only from the VCN, a bastion, or a private path."
  default     = false
}

variable "endpoint_nsg_ids" {
  type        = set(string)
  description = "NSG OCIDs for the Kubernetes API endpoint."
  default     = []
}

variable "cluster_type" {
  type        = string
  description = "OKE cluster type. ENHANCED_CLUSTER is the current cluster type."
  default     = "ENHANCED_CLUSTER"

  validation {
    condition     = contains(["ENHANCED_CLUSTER", "BASIC_CLUSTER"], var.cluster_type)
    error_message = "cluster_type must be ENHANCED_CLUSTER or BASIC_CLUSTER."
  }
}

variable "cni_type" {
  type        = string
  description = "Pod networking. OCI_VCN_IP_NATIVE places pod IPs in subnet CIDRs."
  default     = "OCI_VCN_IP_NATIVE"

  validation {
    condition     = contains(["OCI_VCN_IP_NATIVE", "FLANNEL_OVERLAY"], var.cni_type)
    error_message = "cni_type must be OCI_VCN_IP_NATIVE or FLANNEL_OVERLAY."
  }
}

variable "pods_cidr" {
  type        = string
  description = "Pod CIDR used only with FLANNEL_OVERLAY. Leave null for OCI_VCN_IP_NATIVE."
  default     = null
}

variable "services_cidr" {
  type        = string
  description = "CIDR for Kubernetes services. Must not overlap the VCN."
  default     = "10.96.0.0/16"
}

variable "service_lb_subnet_ids" {
  type        = list(string)
  description = "Subnet OCIDs where Kubernetes LoadBalancer services place OCI load balancers."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "Vault key OCID for Kubernetes secrets encryption. Null uses Oracle-managed encryption."
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
  description = "Worker node pools. Empty creates the control plane only. image_id must be an OKE worker image for the region."
  default     = {}
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
  description = "Defined tags applied to the cluster and node pools."
  default     = {}
}

check "vcn_native_pods_use_subnets" {
  assert {
    condition = var.cni_type != "OCI_VCN_IP_NATIVE" || alltrue([
      for pool in var.node_pools : length(pool.pod_subnet_ids) > 0
    ])
    error_message = "Each node pool needs pod_subnet_ids when cni_type is OCI_VCN_IP_NATIVE."
  }
}

check "flannel_uses_pod_cidr" {
  assert {
    condition     = var.cni_type != "FLANNEL_OVERLAY" || var.pods_cidr != null
    error_message = "Set pods_cidr when cni_type is FLANNEL_OVERLAY."
  }
}
