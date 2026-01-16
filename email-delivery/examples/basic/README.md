# Email Delivery Basic Example

This example creates a minimal email sender.

## Features

- Single email sender
- Suitable for Always Free tier (3,000 emails/month)

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="sender_email=noreply@example.com"
terraform apply
```

## Always Free Considerations

- 3,000 emails per month limit
- Single sender
- Suitable for basic email needs
