# Monitoring Basic Example

This example creates a minimal monitoring alarm.

## Features

- Single CPU utilization alarm
- Basic threshold monitoring
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Basic alarm configuration
- No notification destinations (saves quota)
- Suitable for basic monitoring needs
