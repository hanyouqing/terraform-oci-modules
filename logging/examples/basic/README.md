# Logging Basic Example

This example creates a minimal logging setup.

## Features

- Single log group
- Single service log
- 30-day retention
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Basic logging configuration
- 30-day retention (reasonable for Always Free)
- Suitable for basic log collection
