data "oci_core_subnet" "this" {
  subnet_id = var.subnet_id
}

resource "oci_redis_redis_cluster" "this" {
  compartment_id          = var.compartment_id
  display_name            = var.display_name
  subnet_id               = var.subnet_id
  software_version        = var.software_version
  cluster_mode            = var.cluster_mode
  node_count              = var.node_count
  node_memory_in_gbs      = var.node_memory_in_gbs
  shard_count             = var.shard_count
  nsg_ids                 = var.nsg_ids
  oci_cache_config_set_id = var.oci_cache_config_set_id
  primary_cluster_id      = var.primary_cluster_id

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags

  lifecycle {
    precondition {
      condition     = data.oci_core_subnet.this.prohibit_public_ip_on_vnic
      error_message = "Place the OCI Cache cluster in a private subnet."
    }
  }
}

resource "oci_redis_oci_cache_user" "this" {
  for_each = var.users

  compartment_id = var.compartment_id
  name           = each.key
  description    = each.value.description
  acl_string     = each.value.acl_string
  status         = each.value.status

  authentication_mode {
    authentication_type = "IAM"
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_redis_redis_cluster_attach_oci_cache_user" "this" {
  count = length(var.users) == 0 ? 0 : 1

  redis_cluster_id = oci_redis_redis_cluster.this.id
  oci_cache_users = [
    for name in sort(keys(var.users)) : oci_redis_oci_cache_user.this[name].id
  ]
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/cache"
    Project     = var.project
    Environment = var.environment
  }
}
