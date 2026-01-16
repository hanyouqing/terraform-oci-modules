terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name
  cidr_blocks    = var.vcn_cidr_blocks
  dns_label      = var.vcn_dns_label != null && var.vcn_dns_label != "" ? var.vcn_dns_label : null
  is_ipv6enabled = var.enable_ipv6

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/vcn"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.internet_gateway_display_name
  enabled        = var.internet_gateway_enabled

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/internet-gateway"
    }
  )
}

resource "oci_core_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.nat_gateway_display_name
  block_traffic  = var.nat_gateway_block_traffic

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/nat-gateway"
    }
  )
}

resource "oci_core_service_gateway" "this" {
  count = var.create_service_gateway ? 1 : 0

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.service_gateway_display_name

  dynamic "services" {
    for_each = var.service_gateway_services
    content {
      service_id = services.value.service_id
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/service-gateway"
    }
  )
}

resource "oci_core_subnet" "public" {
  for_each = var.public_subnets

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.display_name
  dns_label                  = each.value.dns_label != "" ? each.value.dns_label : null
  availability_domain        = each.value.availability_domain
  prohibit_public_ip_on_vnic = false
  security_list_ids          = each.value.security_list_ids != null ? each.value.security_list_ids : [oci_core_security_list.public[each.key].id]

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/subnet/public"
      "Type"   = "public"
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_subnet" "private" {
  for_each = var.private_subnets

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.display_name
  dns_label                  = each.value.dns_label != "" ? each.value.dns_label : null
  availability_domain        = each.value.availability_domain
  prohibit_public_ip_on_vnic = true
  security_list_ids          = each.value.security_list_ids != null ? each.value.security_list_ids : [oci_core_security_list.private[each.key].id]

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/subnet/private"
      "Type"   = "private"
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_core_route_table" "public" {
  for_each = var.public_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-route-table"

  route_rules {
    network_entity_id = var.create_internet_gateway ? oci_core_internet_gateway.this[0].id : null
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/route-table/public"
    }
  )
}

resource "oci_core_route_table" "private" {
  for_each = var.private_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-route-table"

  dynamic "route_rules" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      network_entity_id = oci_core_nat_gateway.this[0].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }

  dynamic "route_rules" {
    for_each = var.create_service_gateway ? var.service_gateway_services : []
    content {
      network_entity_id = oci_core_service_gateway.this[0].id
      destination       = route_rules.value.cidr_block
      destination_type  = "SERVICE_CIDR_BLOCK"
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/route-table/private"
    }
  )
}

resource "oci_core_route_table_attachment" "public" {
  for_each = var.public_subnets

  subnet_id      = oci_core_subnet.public[each.key].id
  route_table_id = oci_core_route_table.public[each.key].id
}

resource "oci_core_route_table_attachment" "private" {
  for_each = var.private_subnets

  subnet_id      = oci_core_subnet.private[each.key].id
  route_table_id = oci_core_route_table.private[each.key].id
}

resource "oci_core_security_list" "public" {
  for_each = var.public_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-security-list"

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH from anywhere"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP from anywhere"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 443
      max = 443
    }
    description = "Allow HTTPS from anywhere"
  }

  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outbound traffic"
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/security-list/public"
    }
  )
}

resource "oci_core_security_list" "private" {
  for_each = var.private_subnets

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${each.value.display_name}-security-list"

  ingress_security_rules {
    protocol    = "6"
    source      = var.vcn_cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH from VCN"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.vcn_cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP from VCN"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.vcn_cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    tcp_options {
      min = 443
      max = 443
    }
    description = "Allow HTTPS from VCN"
  }

  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outbound traffic"
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/vcn/security-list/private"
    }
  )
}
