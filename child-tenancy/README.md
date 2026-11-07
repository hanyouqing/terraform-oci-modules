# Child tenancy

Creates one child tenancy in OCI Organizations. Provider 9.11.0 added `oci_tenantmanagercontrolplane_child_tenancy`, including governance status and feature links.

`compartment_id` is the parent tenancy OCID. The default governance status is `OPTED_IN`. Organizations always creates the `CORE` link; `features` only lists extra links.

Creating a child tenancy is not an Always Free action. It sends an activation email and adds a cloud account under the parent subscription.

## Usage

```hcl
module "child_tenancy" {
  source = "../child-tenancy"

  compartment_id    = var.tenancy_id
  tenancy_name      = "labchild"
  home_region       = "us-ashburn-1"
  admin_email       = var.child_admin_email
  governance_status = "OPTED_IN"
  policy_name       = "ChildAdministrators"
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
| [oci_tenantmanagercontrolplane_child_tenancy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/tenantmanagercontrolplane_child_tenancy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Email address of the child tenancy administrator. OCI sends the activation message to this address. | `string` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the parent tenancy. Organizations requires the parent tenancy OCID, not a child compartment. | `string` | n/a | yes |
| <a name="input_features"></a> [features](#input\_features) | Organization links to create in addition to the CORE link, which Organizations always creates. Leave empty to add no extra links. | `list(string)` | `[]` | no |
| <a name="input_governance_status"></a> [governance\_status](#input\_governance\_status) | Whether the parent governs the child tenancy. OPTED\_IN lets the parent manage the child. OPTED\_OUT creates the child without governance. | `string` | `"OPTED_IN"` | no |
| <a name="input_home_region"></a> [home\_region](#input\_home\_region) | Home region of the child tenancy. The parent tenancy must already be subscribed to this region. | `string` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the administrator policy created in the child tenancy. Letters and underscores only. Leave null to let Organizations choose the name. | `string` | `null` | no |
| <a name="input_tenancy_name"></a> [tenancy\_name](#input\_tenancy\_name) | Cloud account name of the child tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_child_tenancy_id"></a> [child\_tenancy\_id](#output\_child\_tenancy\_id) | OCID of the child tenancy work request result. |
<!-- END_TF_DOCS -->
