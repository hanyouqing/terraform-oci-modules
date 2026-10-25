# Basic example: create a single auth token for a user
module "credentials" {
  source = "./modules/credentials"

  user_id = var.user_id

  auth_tokens = {
    cicd = {
      description = "Auth token for CI/CD pipeline"
    }
  }

  project     = var.project
  environment = var.environment
}
