variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID."
}

variable "display_name" {
  type        = string
  description = "Gateway display name."
  default     = "api-gateway-demo"
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID for the gateway."
}

variable "endpoint_type" {
  type        = string
  description = "PRIVATE or PUBLIC."
  default     = "PRIVATE"
}

variable "allow_public_endpoint" {
  type        = bool
  description = "Required when endpoint_type is PUBLIC."
  default     = false
}

variable "deployments" {
  type = map(object({
    path_prefix = string
    routes = list(object({
      path                  = string
      methods               = list(string)
      backend_type          = string
      backend_url           = optional(string)
      stock_response_body   = optional(string)
      stock_response_status = optional(number)
    }))
  }))
  description = "Optional deployments."
  default     = {}
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
