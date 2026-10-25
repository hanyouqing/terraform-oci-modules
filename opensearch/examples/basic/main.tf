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
  display_name                       = "opensearch-basic"
  software_version                   = "2.15.0"
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

  project     = "opensearch"
  environment = "development"
}
