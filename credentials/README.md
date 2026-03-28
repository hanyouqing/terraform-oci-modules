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
<!-- END_TF_DOCS -->
