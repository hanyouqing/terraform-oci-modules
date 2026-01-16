# Vault Basic Example

This example creates a minimal Always Free vault with a software master key.

## Features

- Default vault type
- Single software master key (AES 256)
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Software master keys (unlimited in Always Free)
- No HSM keys (saves costs)
- Suitable for basic encryption needs
