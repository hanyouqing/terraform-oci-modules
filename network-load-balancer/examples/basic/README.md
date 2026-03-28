# Basic Network Load Balancer Example

Creates a single public Network Load Balancer with a TCP listener on port 80. Compatible with OCI Always Free tier (1 NLB per tenancy).

## Always Free Considerations

- Only **1 NLB** is included in Always Free tier
- No bandwidth limits — NLB auto-scales
- No additional charge for backend sets, backends, or listeners

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
