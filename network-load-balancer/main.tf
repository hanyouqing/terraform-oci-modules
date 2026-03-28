# -----------------------------------------------------------------------------
# Locals
# -----------------------------------------------------------------------------

locals {
  is_always_free = var.is_private == false || var.is_private == true

  default_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/network-load-balancer"
      "Project"     = var.project
      "Environment" = var.environment
      "AlwaysFree"  = "true"
    },
    var.freeform_tags
  )
}

# -----------------------------------------------------------------------------
# Network Load Balancer
# -----------------------------------------------------------------------------

resource "oci_network_load_balancer_network_load_balancer" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  subnet_id      = var.subnet_id

  is_private                     = var.is_private
  is_preserve_source_destination = var.is_preserve_source_destination
  is_symmetric_hash_enabled      = var.is_symmetric_hash_enabled
  network_security_group_ids     = var.nsg_ids

  dynamic "reserved_ips" {
    for_each = var.reserved_ips
    content {
      id = reserved_ips.value.id
    }
  }

  freeform_tags = local.default_tags
  defined_tags  = var.defined_tags
}

# -----------------------------------------------------------------------------
# Backend Sets
# -----------------------------------------------------------------------------

resource "oci_network_load_balancer_backend_set" "this" {
  for_each = var.backend_sets

  network_load_balancer_id    = oci_network_load_balancer_network_load_balancer.this.id
  name                        = each.key
  policy                      = each.value.policy
  is_fail_open                = each.value.is_fail_open
  is_instant_failover_enabled = each.value.is_instant_failover
  is_preserve_source          = each.value.is_preserve_source
  ip_version                  = each.value.ip_version

  health_checker {
    protocol            = each.value.health_checker.protocol
    port                = each.value.health_checker.port
    interval_in_millis  = each.value.health_checker.interval_in_millis
    timeout_in_millis   = each.value.health_checker.timeout_in_millis
    retries             = each.value.health_checker.retries
    url_path            = contains(["HTTP", "HTTPS"], each.value.health_checker.protocol) ? each.value.health_checker.url_path : null
    return_code         = contains(["HTTP", "HTTPS"], each.value.health_checker.protocol) ? each.value.health_checker.return_code : null
    request_data        = contains(["UDP", "DNS"], each.value.health_checker.protocol) ? each.value.health_checker.request_data : null
    response_data       = contains(["UDP", "DNS"], each.value.health_checker.protocol) ? each.value.health_checker.response_data : null
    response_body_regex = contains(["HTTP", "HTTPS"], each.value.health_checker.protocol) ? each.value.health_checker.response_body_regex : null
  }
}

# -----------------------------------------------------------------------------
# Backends
# -----------------------------------------------------------------------------

resource "oci_network_load_balancer_backend" "this" {
  for_each = var.backends

  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
  backend_set_name         = each.value.backend_set_name
  port                     = each.value.port
  ip_address               = each.value.ip_address
  target_id                = each.value.target_id
  is_backup                = each.value.is_backup
  is_drain                 = each.value.is_drain
  is_offline               = each.value.is_offline
  weight                   = each.value.weight

  depends_on = [oci_network_load_balancer_backend_set.this]
}

# -----------------------------------------------------------------------------
# Listeners
# -----------------------------------------------------------------------------

resource "oci_network_load_balancer_listener" "this" {
  for_each = var.listeners

  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
  name                     = each.key
  default_backend_set_name = each.value.default_backend_set_name
  port                     = each.value.port
  protocol                 = each.value.protocol
  ip_version               = each.value.ip_version
  is_ppv2enabled           = each.value.is_ppv2enabled

  depends_on = [oci_network_load_balancer_backend_set.this]
}
