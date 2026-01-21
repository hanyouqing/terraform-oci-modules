resource "oci_bastion_bastion" "this" {
  compartment_id               = var.compartment_id
  target_subnet_id             = var.target_subnet_id
  bastion_type                 = var.bastion_type
  name                         = var.name
  client_cidr_block_allow_list = var.client_cidr_block_allow_list
  max_session_ttl_in_seconds   = var.max_session_ttl_in_seconds

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/bastion"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_bastion_session" "this" {
  for_each = var.sessions

  bastion_id   = oci_bastion_bastion.this.id
  display_name = each.value.display_name
  key_details {
    public_key_content = each.value.public_key_content
  }
  target_resource_details {
    session_type                               = each.value.session_type
    target_resource_id                         = each.value.target_resource_id
    target_resource_operating_system_user_name = each.value.target_resource_operating_system_user_name
    target_resource_port                       = each.value.target_resource_port
    target_resource_private_ip_address         = each.value.target_resource_private_ip_address
  }
  session_ttl_in_seconds = each.value.session_ttl_in_seconds
}
