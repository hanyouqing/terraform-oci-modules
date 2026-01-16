# MySQL HeatWave Basic Example

This example creates a minimal Always Free MySQL HeatWave system.

## Features

- Single-node MySQL HeatWave system
- 50 GB data storage (Always Free limit)
- Basic backup policy
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="tenancy_ocid=ocid1.tenancy.oc1..xxxxx" \
  -var="subnet_id=ocid1.subnet.oc1..xxxxx" \
  -var="admin_password=YourSecurePassword123!"
terraform apply
```

## Always Free Considerations

- 50 GB data storage (Always Free limit)
- Single-node system
- 7-day backup retention
- Suitable for development/testing
