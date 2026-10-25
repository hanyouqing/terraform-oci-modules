module "golden_gate" {
  source = "./modules/golden-gate"

  compartment_id     = var.compartment_ocid
  display_name       = "gg-basic"
  connection_type    = var.connection_type
  technology_type    = var.technology_type
  username           = var.username
  host               = var.host
  port               = var.port
  database_name      = var.database_name
  subnet_id          = var.subnet_id
  password_secret_id = var.password_secret_id

  project     = "golden-gate"
  environment = "development"
}
