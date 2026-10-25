# FastConnect complete example

Adds the provider service key and cross-connect mappings to the private virtual circuit. BGP MD5 is not a module input.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="bandwidth_shape_name=1 Gbps" \
  -var="customer_bgp_asn=64512" \
  -var="gateway_id=ocid1.drg.oc1.ap-seoul-1.example" \
  -var="provider_service_id=ocid1.providerservice.oc1.ap-seoul-1.example" \
  -var="provider_service_key_name=example-key"
```
