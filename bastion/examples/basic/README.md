# Bastion Basic Example

This example creates a minimal bastion service.

## Features

- Standard bastion type
- Basic configuration
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="target_subnet_id=ocid1.subnet.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Bastion service is free
- Standard type (no sessions pre-configured)
- Suitable for basic secure access needs
