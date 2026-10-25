resource "oci_apigateway_gateway" "this" {
  compartment_id             = var.compartment_id
  display_name               = var.display_name
  endpoint_type              = var.endpoint_type
  subnet_id                  = var.subnet_id
  certificate_id             = var.certificate_id
  network_security_group_ids = var.nsg_ids

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags

  lifecycle {
    precondition {
      condition     = var.endpoint_type != "PUBLIC" || var.allow_public_endpoint
      error_message = "endpoint_type PUBLIC requires allow_public_endpoint=true."
    }
  }
}

resource "oci_apigateway_deployment" "this" {
  for_each = var.deployments

  compartment_id = var.compartment_id
  gateway_id     = oci_apigateway_gateway.this.id
  display_name   = each.key
  path_prefix    = each.value.path_prefix

  specification {
    dynamic "routes" {
      for_each = each.value.routes
      content {
        path    = routes.value.path
        methods = routes.value.methods

        backend {
          type   = routes.value.backend_type
          url    = routes.value.backend_url
          body   = routes.value.stock_response_body
          status = routes.value.stock_response_status
        }
      }
    }
  }

  freeform_tags = merge(local.tags, var.freeform_tags)
  defined_tags  = var.defined_tags
}

locals {
  tags = {
    ManagedBy   = "terraform"
    Module      = "github.com/hanyouqing/terraform-oci-modules/api-gateway"
    Project     = var.project
    Environment = var.environment
  }
}
