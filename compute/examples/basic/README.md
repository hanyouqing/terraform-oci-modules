# Compute Basic Example

This example creates a minimal Always Free compute instance.

## Features

- Single VM.Standard.E2.1.Micro instance (Always Free)
- Public IP assignment
- Basic monitoring enabled
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="tenancy_ocid=ocid1.tenancy.oc1..xxxxx" \
  -var="subnet_id=ocid1.subnet.oc1..xxxxx" \
  -var="ssh_public_keys=$(cat ~/.ssh/id_rsa.pub)"
terraform apply
```

## Always Free Considerations

- Uses VM.Standard.E2.1.Micro shape (Always Free eligible)
- Single instance (within Always Free limit of 2)
- No block volumes attached (saves storage quota)
- Basic configuration suitable for development/testing
