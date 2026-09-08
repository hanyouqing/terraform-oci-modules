terraform {
  required_version = ">= 1.14.2"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.28"
    }
  }
}
