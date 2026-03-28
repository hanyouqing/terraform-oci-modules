terraform {
  required_version = ">= 1.14.2"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

# Complete example: all credential types with multiple entries
module "credentials" {
  source = "../../"

  user_id = var.user_id

  api_keys = var.api_keys

  auth_tokens = {
    cicd = {
      description = "Auth token for CI/CD pipeline"
    }
    monitoring = {
      description = "Auth token for monitoring integration"
    }
  }

  customer_secret_keys = {
    s3_primary = {
      display_name = "Primary S3-compatible access for Object Storage"
    }
    s3_backup = {
      display_name = "Backup S3-compatible access for Object Storage"
    }
  }

  smtp_credentials = {
    app_notifications = {
      description = "SMTP credential for application notifications"
    }
    alert_emails = {
      description = "SMTP credential for alert emails"
    }
  }

  project     = var.project
  environment = var.environment
}
