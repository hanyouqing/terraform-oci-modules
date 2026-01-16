# Notifications Basic Example

This example creates a minimal notification topic with email subscription.

## Features

- Single notification topic
- Email subscription
- Suitable for Always Free tier (1,000 emails/month)

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="email_endpoint=admin@example.com"
terraform apply
```

## Always Free Considerations

- Email notifications (1,000/month limit)
- Single topic
- Suitable for basic alerting needs
