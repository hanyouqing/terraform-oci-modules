data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "this" {
  compartment_id           = var.compartment_id
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

locals {
  image_id = var.image_id != null ? var.image_id : (
    length(data.oci_core_images.this.images) > 0 ? data.oci_core_images.this.images[0].id : null
  )

  always_free_shapes = [
    "VM.Standard.E2.1.Micro",
    "VM.Standard.A1.Flex"
  ]

  is_always_free = contains(local.always_free_shapes, var.shape)

  shape_config = var.shape == "VM.Standard.A1.Flex" ? {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  } : {}
}

resource "oci_core_instance" "this" {
  count = var.instance_count

  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain != null ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[count.index % length(data.oci_identity_availability_domains.ads.availability_domains)].name
  display_name        = var.display_name != null ? "${var.display_name}-${count.index + 1}" : "compute-instance-${count.index + 1}"
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.shape_config != {} ? [local.shape_config] : []
    content {
      ocpus         = shape_config.value.ocpus
      memory_in_gbs = shape_config.value.memory_in_gbs
    }
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = var.assign_public_ip
    hostname_label         = var.hostname_label != null ? "${var.hostname_label}-${count.index + 1}" : null
    display_name           = var.vnic_display_name != null ? "${var.vnic_display_name}-${count.index + 1}" : null
    skip_source_dest_check = var.skip_source_dest_check
    nsg_ids                = var.nsg_ids
    private_ip             = var.private_ip != null ? var.private_ip : null
  }

  source_details {
    source_type = "image"
    image_id    = local.image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_keys
    user_data           = var.user_data
  }

  agent_config {
    is_monitoring_disabled = !var.enable_monitoring
    is_management_disabled = !var.enable_management_agent
  }

  is_pv_encryption_in_transit_enabled = var.enable_pv_encryption_in_transit

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/compute"
      "Project"     = var.project
      "Environment" = var.environment
      "AlwaysFree"  = tostring(local.is_always_free)
    }
  )

  defined_tags = var.defined_tags

  lifecycle {
    ignore_changes = [
      create_vnic_details[0].private_ip,
      metadata
    ]
  }
}

resource "oci_core_volume" "boot" {
  count = var.create_boot_volume ? var.instance_count : 0

  compartment_id      = var.compartment_id
  availability_domain = oci_core_instance.this[count.index].availability_domain
  display_name        = "${oci_core_instance.this[count.index].display_name}-boot"
  size_in_gbs         = var.boot_volume_size_in_gbs
  vpus_per_gb         = var.boot_volume_vpus_per_gb

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/compute/boot-volume"
    }
  )
}

resource "oci_core_volume_attachment" "boot" {
  count = var.create_boot_volume ? var.instance_count : 0

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.this[count.index].id
  volume_id       = oci_core_volume.boot[count.index].id
  display_name    = "${oci_core_instance.this[count.index].display_name}-boot-attachment"
}

resource "oci_core_volume" "block" {
  for_each = var.block_volumes

  compartment_id = var.compartment_id
  availability_domain = each.value.availability_domain != null ? each.value.availability_domain : (
    var.instance_count > 0 ? oci_core_instance.this[0].availability_domain : null
  )
  display_name         = each.value.display_name
  size_in_gbs          = each.value.size_in_gbs
  vpus_per_gb          = each.value.vpus_per_gb
  is_auto_tune_enabled = each.value.is_auto_tune_enabled

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/compute/block-volume"
    }
  )
}

resource "oci_core_volume_attachment" "block" {
  for_each = var.block_volumes

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.this[each.value.instance_index].id
  volume_id       = oci_core_volume.block[each.key].id
  display_name    = "${each.value.display_name}-attachment"
  device          = each.value.device != null ? each.value.device : null
}
