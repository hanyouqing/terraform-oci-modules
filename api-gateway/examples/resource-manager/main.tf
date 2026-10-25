module "api_gateway" {
  source = "./modules/api-gateway"

  compartment_id        = var.compartment_ocid
  display_name          = var.display_name
  subnet_id             = var.subnet_id
  endpoint_type         = var.endpoint_type
  allow_public_endpoint = var.allow_public_endpoint
  deployments           = var.deployments
  project               = "api-gateway"
  environment           = "basic"
}
