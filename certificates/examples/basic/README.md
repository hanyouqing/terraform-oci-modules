# Certificates Basic Example

This example creates a single root Certificate Authority with a KMS key for protection.

## Features

- Default Vault with software KMS key (Always Free)
- Single root CA (internally generated)
- RSA2048 key with SHA256_WITH_RSA signing
- Suitable for development and testing

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- 5 CAs per tenancy (this example creates 1)
- 150 certificates per tenancy (this example creates 0)
- Software KMS key in Default Vault (free)
- No additional cost within these limits
