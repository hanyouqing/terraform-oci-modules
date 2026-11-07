# WAF

Creates an OCI WAF policy. The policy allows requests that do not match a protection or rate-limit rule, and returns HTTP 403 when a rule matches. Set `load_balancer_id` to attach that policy to an existing flexible load balancer.

Protection capability keys are not defaulted. Confirm `key` and `version` in the target region before apply. WAF is not an Always Free service. The seven solution stacks under `docs/oci-solutions-architect/examples` do not instantiate this module.

## Usage

```hcl
module "waf" {
  source = "../waf"

  compartment_id = var.compartment_id
  display_name   = "edge"

  protection_capabilities = [
    {
      key     = var.protection_capability_key
      version = var.protection_capability_version
    }
  ]

  load_balancer_id = var.load_balancer_id
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
| [oci_waf_web_app_firewall.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waf_web_app_firewall) | resource |
| [oci_waf_web_app_firewall_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waf_web_app_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the WAF policy and firewall. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the policy and firewall. | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the WAF policy. The firewall uses the same name when a load balancer is set. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_load_balancer_id"></a> [load\_balancer\_id](#input\_load\_balancer\_id) | OCID of the flexible load balancer to protect. Null creates the policy only. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_protection_capabilities"></a> [protection\_capabilities](#input\_protection\_capabilities) | Oracle WAF protection capabilities. key and version must exist for the target region. Empty skips request inspection. | <pre>list(object({<br/>    key     = string<br/>    version = number<br/>  }))</pre> | `[]` | no |
| <a name="input_rate_limit"></a> [rate\_limit](#input\_rate\_limit) | Optional request rate limit. Matching clients receive HTTP 403. Null skips rate limiting. | <pre>object({<br/>    period_in_seconds = number<br/>    requests_limit    = number<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | OCID of the WAF firewall. Null when load\_balancer\_id is not set. |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | OCID of the WAF policy. |
<!-- END_TF_DOCS -->
