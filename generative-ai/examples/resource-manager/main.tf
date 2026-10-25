module "generative_ai" {
  source = "./modules/generative-ai"

  compartment_id = var.compartment_ocid
  cluster_type   = "HOSTING"
  unit_count     = var.unit_count
  unit_shape     = var.unit_shape
  display_name   = "genai-hosting"

  project     = "generative-ai"
  environment = "development"
}
