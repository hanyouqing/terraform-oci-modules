resource "oci_opensearch_opensearch_cluster" "this" {
  compartment_id        = var.compartment_id
  display_name          = var.display_name
  software_version      = var.software_version
  vcn_id                = var.vcn_id
  vcn_compartment_id    = coalesce(var.vcn_compartment_id, var.compartment_id)
  subnet_id             = var.subnet_id
  subnet_compartment_id = coalesce(var.subnet_compartment_id, var.compartment_id)

  master_node_count           = var.master_node_count
  master_node_host_type       = var.master_node_host_type
  master_node_host_ocpu_count = var.master_node_host_ocpu_count
  master_node_host_memory_gb  = var.master_node_host_memory_gb

  data_node_count           = var.data_node_count
  data_node_host_type       = var.data_node_host_type
  data_node_host_ocpu_count = var.data_node_host_ocpu_count
  data_node_host_memory_gb  = var.data_node_host_memory_gb
  data_node_storage_gb      = var.data_node_storage_gb

  opendashboard_node_count           = var.opendashboard_node_count
  opendashboard_node_host_ocpu_count = var.opendashboard_node_host_ocpu_count
  opendashboard_node_host_memory_gb  = var.opendashboard_node_host_memory_gb

  security_mode                      = var.security_mode
  security_master_user_name          = var.security_master_user_name
  security_master_user_password_hash = var.security_master_user_password_hash

  dynamic "remote_reindex_trust_config" {
    for_each = length(var.remote_reindex_sources) == 0 ? [] : [1]

    content {
      remote_sources = [
        for source in var.remote_reindex_sources : {
          ca_bundle_id           = source.ca_bundle_id
          certificate_id         = source.certificate_id
          endpoint               = source.endpoint
          endpoint_resolution_ip = source.endpoint_resolution_ip
        }
      ]
    }
  }

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/opensearch"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
