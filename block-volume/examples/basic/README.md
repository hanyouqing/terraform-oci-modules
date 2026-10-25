# Block Storage Basic Example

This example creates a minimal Always Free block volume.

## Features

- Single 50 GB block volume (within Always Free 200 GB limit)
- Standard performance (10 VPUs per GB)
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="tenancy_ocid=ocid1.tenancy.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- 50 GB volume (within 200 GB total limit)
- No backups (saves backup quota)
- Standard performance tier
- Suitable for development/testing workloads
