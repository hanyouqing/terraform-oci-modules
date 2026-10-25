terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.11"
    }
  }
}

module "cache" {
  source = "../../"

  compartment_id     = var.compartment_id
  display_name       = var.display_name
  subnet_id          = var.subnet_id
  software_version   = var.software_version
  cluster_mode       = var.cluster_mode
  node_count         = var.node_count
  node_memory_in_gbs = var.node_memory_in_gbs
  shard_count        = var.shard_count
  nsg_ids            = var.nsg_ids
  users              = var.users

  project     = var.project
  environment = var.environment
}
