resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  name               = var.name
  kubernetes_version = var.kubernetes_version
  vcn_id             = var.vcn_id
  type               = var.cluster_type
  kms_key_id         = var.kms_key_id

  cluster_pod_network_options {
    cni_type = var.cni_type
  }

  endpoint_config {
    subnet_id            = var.endpoint_subnet_id
    is_public_ip_enabled = var.endpoint_public_ip_enabled
    nsg_ids              = var.endpoint_nsg_ids
  }

  options {
    service_lb_subnet_ids = var.service_lb_subnet_ids

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }

    kubernetes_network_config {
      pods_cidr     = var.cni_type == "FLANNEL_OVERLAY" ? var.pods_cidr : null
      services_cidr = var.services_cidr
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_containerengine_node_pool" "this" {
  for_each = var.node_pools

  cluster_id         = oci_containerengine_cluster.this.id
  compartment_id     = var.compartment_id
  name               = each.key
  kubernetes_version = var.kubernetes_version
  node_shape         = each.value.node_shape
  ssh_public_key     = each.value.ssh_public_key

  node_source_details {
    source_type = "IMAGE"
    image_id    = each.value.image_id
  }

  node_shape_config {
    ocpus         = each.value.ocpus
    memory_in_gbs = each.value.memory_in_gbs
  }

  node_config_details {
    size    = each.value.size
    nsg_ids = each.value.nsg_ids

    node_pool_pod_network_option_details {
      cni_type       = var.cni_type
      pod_subnet_ids = var.cni_type == "OCI_VCN_IP_NATIVE" ? each.value.pod_subnet_ids : null
    }

    placement_configs {
      availability_domain = each.value.availability_domain
      subnet_id           = each.value.subnet_id
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/oke"
    Project     = var.project
    Environment = var.environment
  }
}
