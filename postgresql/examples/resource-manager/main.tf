module "postgresql" {
  source = "./modules/postgresql"

  compartment_id              = var.compartment_ocid
  display_name                = "pg-basic"
  db_version                  = "14"
  shape                       = "PostgreSQL.VM.Standard.E4.Flex"
  instance_count              = 1
  instance_ocpu_count         = 2
  instance_memory_size_in_gbs = 10
  subnet_id                   = var.subnet_id
  admin_username              = var.admin_username
  admin_password_secret_id    = var.admin_password_secret_id

  project     = "postgresql"
  environment = "development"
}
