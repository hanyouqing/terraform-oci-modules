# Complete Credentials Example

Creates all credential types for an OCI user: API keys, auth tokens, customer secret keys, and SMTP credentials. Demonstrates production-grade credential management.

## Resources Created

- 2 Auth tokens (CI/CD + monitoring)
- 2 Customer secret keys (primary + backup S3 access)
- 2 SMTP credentials (notifications + alerts)
- API keys (user-provided)

## Always Free

All IAM credentials are Always Free with no charges.

## Usage

```bash
terraform init
terraform plan -var="user_id=ocid1.user.oc1..example"
terraform apply -var="user_id=ocid1.user.oc1..example"

# Retrieve sensitive values (only available at creation time)
terraform output -json auth_token_values
terraform output -json customer_secret_key_keys
terraform output -json smtp_credential_passwords
```

## Production Considerations

- **Credential rotation**: Plan for blue-green rotation by creating new credentials before destroying old ones
- **State encryption**: Use an encrypted remote backend (OCI Object Storage with SSE)
- **Per-user limits**: Auth tokens (2), customer secret keys (2), SMTP credentials (2), API keys (3)
- **Monitoring**: Set up alerts for credential expiration and unauthorized usage

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |
