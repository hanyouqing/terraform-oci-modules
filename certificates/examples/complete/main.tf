terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "certificates" {
  source = "../../"

  compartment_id = var.compartment_id

  certificate_authorities = {
    # Root CA
    root-ca = {
      name              = "${var.project}-root-ca"
      kms_key_id        = var.kms_key_id
      common_name       = "${var.project} Root CA"
      organization      = var.organization
      country           = var.country
      signing_algorithm = "SHA256_WITH_RSA"
      key_algorithm     = "RSA2048"

      certificate_authority_max_validity_duration = "P3650D"
      leaf_certificate_max_validity_duration      = "P365D"
    }

    # Subordinate CA for issuing leaf certificates
    issuing-ca = {
      name                            = "${var.project}-issuing-ca"
      kms_key_id                      = var.kms_key_id
      config_type                     = "SUBORDINATE_CA_ISSUED_BY_INTERNAL_CA"
      issuer_certificate_authority_id = var.root_ca_id
      common_name                     = "${var.project} Issuing CA"
      organization                    = var.organization
      country                         = var.country
      signing_algorithm               = "SHA256_WITH_RSA"
      key_algorithm                   = "RSA2048"

      leaf_certificate_max_validity_duration = "P365D"
    }
  }

  certificates = {
    # Web server certificate with SANs
    web-server = {
      name                     = "${var.project}-web-server"
      ca_key                   = "root-ca"
      certificate_profile_type = "TLS_SERVER_OR_CLIENT"
      common_name              = var.web_server_cn
      organization             = var.organization
      country                  = var.country
      subject_alternative_names = [
        { type = "DNS", value = var.web_server_cn },
        { type = "DNS", value = "*.${var.web_server_cn}" }
      ]
    }

    # API server certificate
    api-server = {
      name                     = "${var.project}-api-server"
      ca_key                   = "root-ca"
      certificate_profile_type = "TLS_SERVER"
      common_name              = "api.${var.web_server_cn}"
      organization             = var.organization
      country                  = var.country
      subject_alternative_names = [
        { type = "DNS", value = "api.${var.web_server_cn}" }
      ]
    }

    # Client certificate for mutual TLS
    client-cert = {
      name                     = "${var.project}-client-cert"
      ca_key                   = "root-ca"
      certificate_profile_type = "TLS_CLIENT"
      common_name              = "client.${var.web_server_cn}"
      organization             = var.organization
      country                  = var.country
    }
  }

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
