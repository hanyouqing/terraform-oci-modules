# FastConnect basic example

Creates a private virtual circuit with BFD enabled. Cross-connect mappings stay empty until the provider allocates them.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="bandwidth_shape_name=1 Gbps" \
  -var="customer_bgp_asn=64512" \
  -var="gateway_id=ocid1.drg.oc1.ap-seoul-1.example" \
  -var="provider_service_id=ocid1.providerservice.oc1.ap-seoul-1.example"
```
