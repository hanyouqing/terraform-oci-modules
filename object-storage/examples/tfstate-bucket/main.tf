terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
    }
  }
}

# Private versioned bucket suitable for Terraform remote state (OCI Object Storage backend).
# Product stacks that use Cloudflare R2 are out of scope for this module example.
module "object_storage" {
  source = "../../"

  compartment_id = var.compartment_id
  region         = var.region

  buckets = {
    tfstate = {
      name                  = var.bucket_name
      namespace             = null
      access_type           = "NoPublicAccess"
      storage_tier          = "Standard"
      versioning            = "Enabled"
      auto_tiering          = "Disabled"
      object_events_enabled = false
      metadata              = {}
      freeform_tags = {
        Purpose = "terraform-state"
      }
      defined_tags = {}
    }
  }

  lifecycle_policies = {}
  preauth_requests   = {}

  project     = var.project
  environment = var.environment
}
