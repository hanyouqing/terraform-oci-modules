# Network Firewall

Creates a Network Firewall policy and a Network Firewall in a subnet. Policy rules (security, NAT, decryption) are not managed here; attach them with separate resources or the Console after the empty policy exists. Not Always Free. The seven solution stacks do not instantiate this module.

## Usage

```hcl
module "network_firewall" {
  source = "../network-firewall"

  compartment_id = var.compartment_id
  display_name   = "edge-nfw"
  subnet_id      = var.firewall_subnet_id
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
| [oci_network_firewall_network_firewall.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_firewall_network_firewall) | resource |
| [oci_network_firewall_network_firewall_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_firewall_network_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability Domain for the firewall. Null lets the service choose when supported. | `string` | `null` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment OCID for the Network Firewall and policy. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the firewall and policy. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the Network Firewall. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_ipv4address"></a> [ipv4address](#input\_ipv4address) | Optional fixed IPv4 address in the subnet. | `string` | `null` | no |
| <a name="input_must_enable_private_nat"></a> [must\_enable\_private\_nat](#input\_must\_enable\_private\_nat) | When set, configures private NAT on the firewall. Null skips the block. | `bool` | `null` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | NSG OCIDs attached to the firewall. | `list(string)` | `[]` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description for the firewall policy. | `string` | `"Managed by terraform-oci-modules/network-firewall"` | no |
| <a name="input_policy_display_name"></a> [policy\_display\_name](#input\_policy\_display\_name) | Display name for the firewall policy. Null derives from display\_name. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | Firewall shape that sets throughput. Confirm the value in the target region. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet OCID where the firewall attaches. Prefer a dedicated firewall subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ipv4address"></a> [ipv4address](#output\_ipv4address) | IPv4 address of the firewall. |
| <a name="output_network_firewall_id"></a> [network\_firewall\_id](#output\_network\_firewall\_id) | OCID of the Network Firewall. |
| <a name="output_network_firewall_policy_id"></a> [network\_firewall\_policy\_id](#output\_network\_firewall\_policy\_id) | OCID of the Network Firewall policy. |
<!-- END_TF_DOCS -->
