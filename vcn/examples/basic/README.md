# VCN Basic Example

This example creates a minimal VCN setup suitable for Always Free tier resources.

## Features

- Single VCN with one public subnet
- Internet Gateway for public access
- Basic security lists with SSH, HTTP, and HTTPS access
- Suitable for Always Free compute instances

## Usage

```bash
terraform init
terraform plan -var="compartment_id=ocid1.compartment.oc1..xxxxx" -var="tenancy_ocid=ocid1.tenancy.oc1..xxxxx"
terraform apply
```

## Always Free Considerations

- Uses minimal resources (1 VCN, 1 public subnet)
- No NAT Gateway (saves costs)
- No Service Gateway (not needed for basic Always Free usage)
- No DRG (not needed for Always Free)
