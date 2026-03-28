# Complete Network Load Balancer Example

Creates a production-grade Network Load Balancer with multiple listeners, backend sets, and protocols. Demonstrates TCP, UDP, and HTTP health check configurations.

## Resources Created

- 1 Network Load Balancer (public, source preservation enabled)
- 3 Backend sets (HTTP, TCP, UDP with different policies)
- 5 Backends across backend sets
- 3 Listeners (HTTP on 80, HTTPS passthrough on 443, DNS on 53/UDP)

## Features Demonstrated

- Multiple load balancing policies (FIVE_TUPLE, THREE_TUPLE)
- HTTP health checks with response body regex validation
- TCP health checks for TLS passthrough
- UDP listener for DNS traffic
- Source/destination preservation
- Symmetric hash for bidirectional flows
- NSG integration
- Custom tagging

## Production Considerations

- **TLS**: NLB operates at Layer 4 — TLS termination must happen at the backend
- **Health checks**: Use HTTP health checks for application-level validation
- **NSGs**: Always restrict NLB access to known source CIDRs
- **Monitoring**: Set up OCI Monitoring alarms for backend health status
- **Reserved IPs**: Use reserved IPs for stable DNS configuration

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1..example"
terraform apply \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1..example"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 7.30 |
