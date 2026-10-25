resource "oci_network_firewall_network_firewall_policy" "this" {
  compartment_id = var.compartment_id
  display_name   = coalesce(var.policy_display_name, "${var.display_name}-policy")
  description    = var.policy_description

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

resource "oci_network_firewall_network_firewall" "this" {
  compartment_id             = var.compartment_id
  display_name               = var.display_name
  subnet_id                  = var.subnet_id
  network_firewall_policy_id = oci_network_firewall_network_firewall_policy.this.id
  availability_domain        = var.availability_domain
  network_security_group_ids = var.nsg_ids
  ipv4address                = var.ipv4address
  shape                      = var.shape

  dynamic "nat_configuration" {
    for_each = var.must_enable_private_nat == null ? [] : [var.must_enable_private_nat]
    content {
      must_enable_private_nat = nat_configuration.value
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/network-firewall"
    Project     = var.project
    Environment = var.environment
  }
}
