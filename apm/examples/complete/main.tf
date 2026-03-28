terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "apm" {
  source = "../../"

  compartment_id = var.compartment_id

  apm_domains = {
    main = {
      display_name = "${var.project}-apm"
      description  = "APM domain for ${var.project} ${var.environment}"
      is_free_tier = var.is_free_tier
    }
  }

  synthetics_monitors = {
    # REST health check — lightweight, runs every 6 minutes (10/hour)
    health-check = {
      display_name               = "${var.project}-health-check"
      apm_domain_key             = "main"
      monitor_type               = "REST"
      repeat_interval_in_seconds = 360
      target                     = var.health_check_url
      vantage_points             = var.vantage_points
      timeout_in_seconds         = 30
    }

    # Browser monitor — full page load test, runs every 12 minutes (5/hour)
    browser-check = {
      display_name               = "${var.project}-browser-check"
      apm_domain_key             = "main"
      monitor_type               = "BROWSER"
      repeat_interval_in_seconds = 720
      target                     = var.browser_check_url
      vantage_points             = var.vantage_points
      timeout_in_seconds         = 60
    }

    # DNS monitor — verify DNS resolution
    dns-check = {
      display_name               = "${var.project}-dns-check"
      apm_domain_key             = "main"
      monitor_type               = "DNS"
      repeat_interval_in_seconds = 720
      target                     = var.dns_check_target
      vantage_points             = var.vantage_points
      timeout_in_seconds         = 30
    }
  }

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
