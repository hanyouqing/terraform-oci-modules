# Autonomous Database Basic Example

This example creates a minimal Always Free Autonomous Database.

## Features

- Single Always Free Autonomous Database (1 OCPU, 20 GB)
- OLTP workload type
- Public access (whitelisted IPs)
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="admin_password=YourSecurePassword123!"
terraform apply
```

## Always Free Considerations

- 1 OCPU and 20 GB storage (Always Free limits)
- Free tier enabled
- Public endpoint (no private endpoint needed)
- Suitable for development/testing workloads
