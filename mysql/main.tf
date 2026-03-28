resource "oci_mysql_mysql_db_system" "this" {
  for_each = var.mysql_systems

  compartment_id      = var.compartment_id
  display_name        = each.value.display_name
  availability_domain = each.value.availability_domain
  shape_name          = each.value.shape_name
  subnet_id           = each.value.subnet_id
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password

  mysql_version    = each.value.mysql_version
  configuration_id = each.value.configuration_id

  data_storage_size_in_gb = each.value.data_storage_size_in_gb

  backup_policy {
    is_enabled        = each.value.backup_policy.is_enabled
    retention_in_days = each.value.backup_policy.retention_in_days
    window_start_time = each.value.backup_policy.window_start_time
  }

  freeform_tags = merge(
    {
      "ManagedBy"  = "terraform"
      "Module"     = "github.com/hanyouqing/terraform-oci-modules/mysql"
      "AlwaysFree" = tostring(each.value.shape_name == "MySQL.Free")
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
