terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

module "mysql" {
  source = "../../"

  compartment_id = var.compartment_id

  mysql_systems = {
    mysql-1 = {
      display_name            = "always-free-mysql"
      availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
      shape_name              = "MySQL.HeatWave.VM.Standard.E3.1.8GB"
      subnet_id               = var.subnet_id
      admin_username          = "admin"
      admin_password          = var.admin_password
      mysql_version           = "8.0.35"
      configuration_id        = null
      data_storage_size_in_gb = 50
      backup_policy = {
        is_enabled        = true
        retention_in_days = 7
        window_start_time = "02:00"
      }
    }
  }

  project     = "always-free"
  environment = "development"
}
