# NoSQL Database Basic Example

This example creates a single Always Free NoSQL table.

## Features

- Single NoSQL table with simple schema
- Always Free tier limits (50 read/write units, 25 GB)
- PROVISIONED capacity mode
- Suitable for development and testing

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Up to 3 tables per tenancy (this example creates 1)
- 25 GB storage per table
- 133 million read + 133 million write units/month shared across tables
- No additional cost within these limits
