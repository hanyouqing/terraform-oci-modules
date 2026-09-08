data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "this" {
  compartment_id           = var.compartment_id
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.shape
  sort_by                  = var.image_sort_by
  sort_order               = var.image_sort_order
}

locals {
  image_id = var.image_id != null ? var.image_id : (
    length(data.oci_core_images.this.images) > 0 ? data.oci_core_images.this.images[0].id : null
  )

  # Always Free shapes: VM.Standard.E2.1.Micro and VM.Standard.A1.Flex
  is_always_free = var.shape == "VM.Standard.E2.1.Micro" || var.shape == "VM.Standard.A1.Flex"

  shape_config_list = contains(var.flexible_shapes, var.shape) ? [{
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }] : []

  launch_options_list      = var.launch_options != null ? [var.launch_options] : []
  instance_options_list    = var.instance_options != null ? [var.instance_options] : []
  availability_config_list = var.availability_config != null ? [var.availability_config] : []
}

resource "oci_core_instance" "this" {
  count = var.instance_count

  compartment_id       = var.compartment_id
  availability_domain  = var.availability_domain != null ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[count.index % length(data.oci_identity_availability_domains.ads.availability_domains)].name
  fault_domain         = var.fault_domain
  display_name         = var.display_name != null ? "${var.display_name}-${count.index + 1}" : "compute-instance-${count.index + 1}"
  shape                = var.shape
  preserve_boot_volume = var.preserve_boot_volume

  dynamic "shape_config" {
    for_each = local.shape_config_list
    content {
      ocpus         = shape_config.value.ocpus
      memory_in_gbs = shape_config.value.memory_in_gbs
    }
  }

  dynamic "launch_options" {
    for_each = local.launch_options_list
    content {
      boot_volume_type                    = launch_options.value.boot_volume_type
      firmware                            = launch_options.value.firmware
      network_type                        = launch_options.value.network_type
      remote_data_volume_type             = launch_options.value.remote_data_volume_type
      is_pv_encryption_in_transit_enabled = launch_options.value.is_pv_encryption_in_transit_enabled
      is_consistent_volume_naming_enabled = launch_options.value.is_consistent_volume_naming_enabled
    }
  }

  dynamic "instance_options" {
    for_each = local.instance_options_list
    content {
      are_legacy_imds_endpoints_disabled = instance_options.value.are_legacy_imds_endpoints_disabled
    }
  }

  dynamic "availability_config" {
    for_each = local.availability_config_list
    content {
      is_live_migration_preferred = availability_config.value.is_live_migration_preferred
      recovery_action             = availability_config.value.recovery_action
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
    source_type             = "image"
    source_id               = local.image_id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
    boot_volume_vpus_per_gb = var.boot_volume_vpus_per_gb
  }

  metadata = merge(
    {
      ssh_authorized_keys = var.ssh_public_keys
    },
    var.user_data != null ? { user_data = var.user_data } : {}
  )

  extended_metadata = var.extended_metadata

  agent_config {
    is_monitoring_disabled = !var.enable_monitoring
    is_management_disabled = !var.enable_management_agent
  }

  is_pv_encryption_in_transit_enabled = var.enable_pv_encryption_in_transit

  freeform_tags = merge(
    {
      "ManagedBy"  = "terraform"
      "Module"     = "github.com/hanyouqing/terraform-oci-modules/compute"
      "AlwaysFree" = tostring(local.is_always_free)
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags

  lifecycle {
    ignore_changes = [
      create_vnic_details[0].private_ip,
      metadata["user_data"]
    ]

    precondition {
      condition     = local.image_id != null
      error_message = "No compute image found. Set image_id or adjust image_operating_system / image_operating_system_version / shape."
    }

    precondition {
      condition = !(var.shape == "VM.Standard.A1.Flex" && var.instance_count > 0) || (
        var.ocpus * var.instance_count <= 4 && var.memory_in_gbs * var.instance_count <= 24
      )
      error_message = "Always Free A1.Flex tenancy quota is at most 4 OCPUs and 24 GB memory across instances in this module call."
    }
  }
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
    {
      "ManagedBy" = "terraform"
      "Module"    = "github.com/hanyouqing/terraform-oci-modules/compute/block-volume"
    },
    var.freeform_tags
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
