resource "oci_load_balancer_load_balancer" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  shape          = var.shape
  is_private     = var.is_private

  shape_details {
    minimum_bandwidth_in_mbps = var.shape_details.minimum_bandwidth_in_mbps
    maximum_bandwidth_in_mbps = var.shape_details.maximum_bandwidth_in_mbps
  }

  subnet_ids = var.subnet_ids
  nsg_ids    = var.nsg_ids

  freeform_tags = merge(
    var.freeform_tags,
    {
      "Module"      = "terraform-oci-modules/load-balancer"
      "Project"     = var.project
      "Environment" = var.environment
    }
  )

  defined_tags = var.defined_tags
}

resource "oci_load_balancer_backend_set" "this" {
  for_each = var.backend_sets

  load_balancer_id = oci_load_balancer_load_balancer.this.id
  name             = each.key
  policy           = each.value.policy

  health_checker {
    protocol            = each.value.health_checker.protocol
    port                = each.value.health_checker.port
    url_path            = each.value.health_checker.url_path
    interval_ms         = each.value.health_checker.interval_ms
    timeout_in_millis   = each.value.health_checker.timeout_in_millis
    retries             = each.value.health_checker.retries
    response_body_regex = each.value.health_checker.response_body_regex
  }

  dynamic "ssl_configuration" {
    for_each = each.value.ssl_configuration != null ? [each.value.ssl_configuration] : []
    content {
      certificate_ids                   = ssl_configuration.value.certificate_ids
      certificate_name                  = ssl_configuration.value.certificate_name
      verify_depth                      = ssl_configuration.value.verify_depth
      verify_peer_certificate           = ssl_configuration.value.verify_peer_certificate
      protocols                         = ssl_configuration.value.protocols
      cipher_suite_name                 = ssl_configuration.value.cipher_suite_name
      server_order_preference           = ssl_configuration.value.server_order_preference
      trusted_certificate_authority_ids = ssl_configuration.value.trusted_certificate_authority_ids
    }
  }
}

resource "oci_load_balancer_backend" "this" {
  for_each = var.backends

  load_balancer_id = oci_load_balancer_load_balancer.this.id
  backendset_name  = each.value.backendset_name
  ip_address       = each.value.ip_address
  port             = each.value.port
  backup           = each.value.backup
  drain            = each.value.drain
  offline          = each.value.offline
  weight           = each.value.weight
}

resource "oci_load_balancer_listener" "this" {
  for_each = var.listeners

  load_balancer_id         = oci_load_balancer_load_balancer.this.id
  name                     = each.key
  default_backend_set_name = each.value.default_backend_set_name
  port                     = each.value.port
  protocol                 = each.value.protocol

  dynamic "ssl_configuration" {
    for_each = each.value.ssl_configuration != null ? [each.value.ssl_configuration] : []
    content {
      certificate_ids                   = ssl_configuration.value.certificate_ids
      certificate_name                  = ssl_configuration.value.certificate_name
      verify_depth                      = ssl_configuration.value.verify_depth
      verify_peer_certificate           = ssl_configuration.value.verify_peer_certificate
      protocols                         = ssl_configuration.value.protocols
      cipher_suite_name                 = ssl_configuration.value.cipher_suite_name
      server_order_preference           = ssl_configuration.value.server_order_preference
      trusted_certificate_authority_ids = ssl_configuration.value.trusted_certificate_authority_ids
    }
  }

  connection_configuration {
    idle_timeout_in_seconds = each.value.connection_configuration.idle_timeout_in_seconds
  }
}
