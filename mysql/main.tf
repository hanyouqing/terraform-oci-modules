resource "oci_mysql_mysql_db_system" "this" {
  for_each = toset(nonsensitive(keys(var.mysql_systems)))

  compartment_id      = var.compartment_id
  display_name        = var.mysql_systems[each.key].display_name
  availability_domain = var.mysql_systems[each.key].availability_domain
  shape_name          = var.mysql_systems[each.key].shape_name
  subnet_id           = var.mysql_systems[each.key].subnet_id
  admin_username      = var.mysql_systems[each.key].admin_username
  admin_password      = var.mysql_systems[each.key].admin_password

  mysql_version    = var.mysql_systems[each.key].mysql_version
  configuration_id = var.mysql_systems[each.key].configuration_id

  data_storage_size_in_gb = var.mysql_systems[each.key].data_storage_size_in_gb

  backup_policy {
    is_enabled        = var.mysql_systems[each.key].backup_policy.is_enabled
    retention_in_days = var.mysql_systems[each.key].backup_policy.retention_in_days
    window_start_time = var.mysql_systems[each.key].backup_policy.window_start_time
  }

  freeform_tags = merge(
    {
      "ManagedBy"  = "terraform"
      "Module"     = "github.com/hanyouqing/terraform-oci-modules/mysql"
      "AlwaysFree" = tostring(var.mysql_systems[each.key].shape_name == "MySQL.Free")
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
