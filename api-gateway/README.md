# API Gateway

Creates an API Gateway and optional deployments. Defaults to a PRIVATE endpoint. Set `allow_public_endpoint=true` for PUBLIC. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "api_gateway" {
  source = "../api-gateway"

  compartment_id = var.compartment_id
  display_name   = "app-gw"
  subnet_id      = var.private_subnet_id
  endpoint_type  = "PRIVATE"
}
```

## Resource Manager

`examples/resource-manager` is a stack for OCI Resource Manager on Terraform 1.5.x. Zip that directory (do not include `.terraform`) and upload it as a stack. Choose Terraform 1.5.x. Resource Manager fills the tenancy and region. Set the compartment and the remaining required fields, then plan and apply.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 1.6.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.11 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.11 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_apigateway_deployment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/apigateway_deployment) | resource |
| [oci_apigateway_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/apigateway_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow_public_endpoint"></a> [allow\_public\_endpoint](#input\_allow\_public\_endpoint) | Explicit approval for a PUBLIC gateway endpoint. | `bool` | `false` | no |
| <a name="input_certificate_id"></a> [certificate\_id](#input\_certificate\_id) | Optional Certificates service certificate OCID for TLS on the gateway. | `string` | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID for the API Gateway. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the gateway and deployments. | `map(string)` | `{}` | no |
| <a name="input_deployments"></a> [deployments](#input\_deployments) | Optional deployments keyed by display name. Use STOCK\_RESPONSE\_BACKEND for a lab without a real backend URL. | <pre>map(object({<br/>    path_prefix = string<br/>    routes = list(object({<br/>      path                  = string<br/>      methods               = list(string)<br/>      backend_type          = string<br/>      backend_url           = optional(string)<br/>      stock_response_body   = optional(string)<br/>      stock_response_status = optional(number)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the gateway. | `string` | n/a | yes |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | PRIVATE keeps the gateway on a private IP. PUBLIC assigns a public IP and needs allow\_public\_endpoint=true. | `string` | `"PRIVATE"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | NSG OCIDs for the gateway. | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet OCID for the gateway. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_deployment_endpoints"></a> [deployment\_endpoints](#output\_deployment\_endpoints) | Deployment endpoint URLs keyed by display name. |
| <a name="output_deployment_ids"></a> [deployment\_ids](#output\_deployment\_ids) | Deployment OCIDs keyed by display name. |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | OCID of the API Gateway. |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Hostname of the gateway. |
<!-- END_TF_DOCS -->
