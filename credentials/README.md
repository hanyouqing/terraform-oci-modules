# OCI Credentials Module

Manages OCI IAM credentials for a user, including API signing keys, auth tokens, customer secret keys (S3-compatible), and SMTP credentials.

## Features

- **API Keys**: RSA key pairs for OCI API request signing
- **Auth Tokens**: Oracle-compatible authentication tokens (Swift, HDFS)
- **Customer Secret Keys**: Amazon S3-compatible access keys for Object Storage
- **SMTP Credentials**: Username/password for OCI Email Delivery SMTP
- **Sensitive Output Handling**: All secrets marked `sensitive = true`
- **For-Each Pattern**: Manage multiple credentials per type via map variables

## Always Free Limits

| Credential Type | Limit per User | Cost |
|-----------------|---------------|------|
| API Keys | 3 | Free |
| Auth Tokens | 2 | Free |
| Customer Secret Keys | 2 | Free |
| SMTP Credentials | 2 | Free |

All IAM credentials are **Always Free** with no charges.

## Usage

```hcl
module "credentials" {
  source = "github.com/hanyouqing/terraform-oci-modules//credentials"

  user_id = "ocid1.user.oc1..example"

  auth_tokens = {
    cicd = {
      description = "Token for CI/CD pipeline"
    }
  }

  customer_secret_keys = {
    s3_access = {
      display_name = "S3-compatible access for Object Storage"
    }
  }

  smtp_credentials = {
    app_email = {
      description = "SMTP credential for application email"
    }
  }
}
```

## Important Notes

- **Secrets are one-time**: Auth token values, customer secret keys, and SMTP passwords are only available at creation time. Use `terraform output -json <output_name>` to retrieve them.
- **Per-user limits**: OCI enforces strict limits (see table above). Exceeding them will cause Terraform errors.
- **Rotation**: Destroy and recreate credentials to rotate. Plan for downtime or use blue-green credential pairs.
- **State security**: Sensitive values are stored in Terraform state. Encrypt your state backend.

## Cost Estimate

| Resource | Monthly Cost |
|----------|-------------|
| API Keys | $0.00 |
| Auth Tokens | $0.00 |
| Customer Secret Keys | $0.00 |
| SMTP Credentials | $0.00 |
| **Total** | **$0.00** |

## Cost Optimization Tips

- Delete unused credentials to free up per-user slots
- Use instance principals (dynamic groups) instead of API keys where possible
- Rotate credentials regularly to maintain security posture

## Examples

- [Basic](examples/basic/) — Single auth token for a user
- [Complete](examples/complete/) — All credential types with multiple entries

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_api_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key) | resource |
| [oci_identity_auth_token.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_auth_token) | resource |
| [oci_identity_customer_secret_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [oci_identity_smtp_credential.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_smtp_credential) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_keys"></a> [api\_keys](#input\_api\_keys) | Map of API signing keys to create. Each key requires a PEM-encoded RSA public key. | <pre>map(object({<br/>    key_value = string<br/>  }))</pre> | `{}` | no |
| <a name="input_auth_tokens"></a> [auth\_tokens](#input\_auth\_tokens) | Map of auth tokens to create. Auth tokens are Oracle-compatible authentication tokens for services like Swift and HDFS. | <pre>map(object({<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_customer_secret_keys"></a> [customer\_secret\_keys](#input\_customer\_secret\_keys) | Map of customer secret keys to create. Used for Amazon S3-compatible API access to Object Storage. | <pre>map(object({<br/>    display_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (where supported) | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., development, staging, production). | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources (where supported) | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name used for tagging and naming. | `string` | `"oci-modules"` | no |
| <a name="input_smtp_credentials"></a> [smtp\_credentials](#input\_smtp\_credentials) | Map of SMTP credentials to create. Used for sending email via OCI Email Delivery SMTP interface. | <pre>map(object({<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_user_id"></a> [user\_id](#input\_user\_id) | The OCID of the user to manage credentials for. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_key_fingerprints"></a> [api\_key\_fingerprints](#output\_api\_key\_fingerprints) | Map of API key fingerprints. |
| <a name="output_api_key_ids"></a> [api\_key\_ids](#output\_api\_key\_ids) | Map of API key identifiers. |
| <a name="output_auth_token_ids"></a> [auth\_token\_ids](#output\_auth\_token\_ids) | Map of auth token identifiers. |
| <a name="output_auth_token_values"></a> [auth\_token\_values](#output\_auth\_token\_values) | Map of auth token values. Only available at creation time. |
| <a name="output_customer_secret_key_ids"></a> [customer\_secret\_key\_ids](#output\_customer\_secret\_key\_ids) | Map of customer secret key identifiers (access key IDs). |
| <a name="output_customer_secret_key_keys"></a> [customer\_secret\_key\_keys](#output\_customer\_secret\_key\_keys) | Map of customer secret key values. Only available at creation time. |
| <a name="output_smtp_credential_ids"></a> [smtp\_credential\_ids](#output\_smtp\_credential\_ids) | Map of SMTP credential identifiers. |
| <a name="output_smtp_credential_passwords"></a> [smtp\_credential\_passwords](#output\_smtp\_credential\_passwords) | Map of SMTP passwords. Only available at creation time. |
| <a name="output_smtp_credential_usernames"></a> [smtp\_credential\_usernames](#output\_smtp\_credential\_usernames) | Map of SMTP usernames. |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Helpful reminders and next steps for credential management. |
<!-- END_TF_DOCS -->
