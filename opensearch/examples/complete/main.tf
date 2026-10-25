terraform {
  required_version = ">= 1.5.0, < 1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "opensearch" {
  source = "../../"

  compartment_id                     = var.compartment_id
  display_name                       = "opensearch-reindex"
  software_version                   = var.software_version
  vcn_id                             = var.vcn_id
  subnet_id                          = var.subnet_id
  master_node_count                  = 1
  master_node_host_ocpu_count        = 1
  master_node_host_memory_gb         = 20
  data_node_count                    = 1
  data_node_host_ocpu_count          = 2
  data_node_host_memory_gb           = 20
  data_node_storage_gb               = 50
  opendashboard_node_count           = 1
  opendashboard_node_host_ocpu_count = 2
  opendashboard_node_host_memory_gb  = 10
  security_master_user_name          = var.security_master_user_name
  security_master_user_password_hash = var.security_master_user_password_hash

  remote_reindex_sources = [
    {
      ca_bundle_id           = var.remote_ca_bundle_id
      endpoint               = var.remote_endpoint
      endpoint_resolution_ip = var.remote_endpoint_resolution_ip
    }
  ]

  project     = "opensearch"
  environment = "production"
}
