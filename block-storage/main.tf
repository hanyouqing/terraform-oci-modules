data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_volume" "this" {
  for_each = var.volumes

  compartment_id       = var.compartment_id
  availability_domain  = each.value.availability_domain
  display_name         = each.value.display_name
  size_in_gbs          = each.value.size_in_gbs
  vpus_per_gb          = each.value.vpus_per_gb
  is_auto_tune_enabled = each.value.is_auto_tune_enabled
  backup_policy_id     = each.value.backup_policy_id

  freeform_tags = merge(
    var.freeform_tags,
    each.value.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/block-storage"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = merge(
    var.defined_tags,
    each.value.defined_tags
  )
}

resource "oci_core_volume_backup" "this" {
  for_each = var.create_backups ? var.volumes : {}

  volume_id    = oci_core_volume.this[each.key].id
  display_name = "${each.value.display_name}-backup"
  type         = each.value.backup_type

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/block-storage/backup"
    }
  )
}

resource "oci_core_volume_backup_policy" "this" {
  for_each = var.backup_policies

  compartment_id = var.compartment_id
  display_name   = each.value.display_name

  dynamic "schedules" {
    for_each = each.value.schedules
    content {
      backup_type       = schedules.value.backup_type
      period            = schedules.value.period
      retention_seconds = schedules.value.retention_seconds
      hour_of_day       = schedules.value.hour_of_day
      day_of_month      = schedules.value.day_of_month
      day_of_week       = schedules.value.day_of_week
      month             = schedules.value.month
      time_zone         = schedules.value.time_zone
    }
  }

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/block-storage/backup-policy"
    }
  )
}

resource "oci_core_volume_attachment" "this" {
  for_each = var.volume_attachments

  attachment_type = each.value.attachment_type
  instance_id     = each.value.instance_id
  volume_id       = oci_core_volume.this[each.value.volume_key].id
  display_name    = each.value.display_name
  device          = each.value.device
  is_read_only    = each.value.is_read_only
  is_shareable    = each.value.is_shareable

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module" = "terraform-oci-modules/block-storage/attachment"
    }
  )
}
