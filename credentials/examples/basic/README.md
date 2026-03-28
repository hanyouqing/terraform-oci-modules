# Basic Credentials Example

Creates a single auth token for an OCI user. This is the simplest use case — suitable for CI/CD pipelines or service integrations.

## Always Free

All IAM credentials are Always Free with no charges.

## Usage

```bash
terraform init
terraform plan -var="user_id=ocid1.user.oc1..example"
terraform apply -var="user_id=ocid1.user.oc1..example"

# Retrieve the token value (only available at creation time)
terraform output -json auth_token_values
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |
