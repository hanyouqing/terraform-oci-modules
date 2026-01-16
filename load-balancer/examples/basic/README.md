# Load Balancer Basic Example

This example creates a minimal Always Free flexible load balancer.

## Features

- Flexible load balancer with 10 Mbps bandwidth (Always Free limit)
- Single backend set with HTTP health check
- HTTP listener on port 80
- Suitable for Always Free tier

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="subnet_ids=[ocid1.subnet.oc1..xxxxx]"
terraform apply
```

## Always Free Considerations

- Flexible shape with 10 Mbps bandwidth (Always Free limit)
- Single backend set
- HTTP only (no SSL/TLS to save costs)
- Suitable for basic load balancing needs
