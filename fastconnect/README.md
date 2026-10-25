# FastConnect

Creates one FastConnect virtual circuit and terminates a private circuit on a DRG you already have. The VCN module creates that DRG. This module does not order a cross-connect, and it does not accept a BGP MD5 key because the provider stores that key in state.

FastConnect is not an Always Free service. Leave `cross_connect_mappings` empty until the provider allocates the circuit. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "fastconnect" {
  source = "../fastconnect"

  compartment_id       = var.compartment_id
  display_name         = "partner-private"
  bandwidth_shape_name = "1 Gbps"
  customer_bgp_asn     = 64512
  gateway_id           = var.drg_id
  provider_service_id  = var.provider_service_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
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
| [oci_core_virtual_circuit.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_virtual_circuit) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bandwidth_shape_name"></a> [bandwidth\_shape\_name](#input\_bandwidth\_shape\_name) | Provider bandwidth shape, for example 1 Gbps. Confirm the name with the FastConnect provider in the target region. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the virtual circuit. | `string` | n/a | yes |
| <a name="input_cross_connect_mappings"></a> [cross\_connect\_mappings](#input\_cross\_connect\_mappings) | BGP peering and cross-connect mappings. Leave empty until the provider has allocated the cross-connect. BGP MD5 keys are not accepted here because the provider stores them in state. | <pre>list(object({<br/>    cross_connect_or_cross_connect_group_id = optional(string)<br/>    customer_bgp_peering_ip                 = optional(string)<br/>    oracle_bgp_peering_ip                   = optional(string)<br/>    vlan                                    = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_customer_bgp_asn"></a> [customer\_bgp\_asn](#input\_customer\_bgp\_asn) | BGP ASN of the customer edge. Use a private ASN unless the provider requires a public one. | `number` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the virtual circuit. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the virtual circuit. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_gateway_id"></a> [gateway\_id](#input\_gateway\_id) | OCID of the DRG that terminates a private virtual circuit. | `string` | n/a | yes |
| <a name="input_ip_mtu"></a> [ip\_mtu](#input\_ip\_mtu) | IP MTU advertised on the circuit. Leave null to accept the provider default. | `string` | `null` | no |
| <a name="input_is_bfd_enabled"></a> [is\_bfd\_enabled](#input\_is\_bfd\_enabled) | Enable BFD on the virtual circuit so a failed path is detected without waiting for BGP hold time. | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_provider_remote_region"></a> [provider\_remote\_region](#input\_provider\_remote\_region) | Remote OCI region for a remote-peering style provider circuit. Leave null for a partner or colocation circuit. | `string` | `null` | no |
| <a name="input_provider_service_id"></a> [provider\_service\_id](#input\_provider\_service\_id) | OCID of the FastConnect provider service. This is not created by the module. | `string` | n/a | yes |
| <a name="input_provider_service_key_name"></a> [provider\_service\_key\_name](#input\_provider\_service\_key\_name) | Provider service key issued for this circuit. Leave null until the provider has issued one. | `string` | `null` | no |
| <a name="input_routing_policy"></a> [routing\_policy](#input\_routing\_policy) | Optional OCI routing policy names for a public virtual circuit. | `list(string)` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | PRIVATE terminates on a DRG. PUBLIC advertises public prefixes. | `string` | `"PRIVATE"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_virtual_circuit_id"></a> [virtual\_circuit\_id](#output\_virtual\_circuit\_id) | OCID of the FastConnect virtual circuit. |
| <a name="output_virtual_circuit_state"></a> [virtual\_circuit\_state](#output\_virtual\_circuit\_state) | Lifecycle state of the virtual circuit. |
<!-- END_TF_DOCS -->
