# WAF complete example

Attaches the policy to a flexible load balancer. Supply protection capability keys that exist in the target region. `9300000` in the command below is a sample key. A match returns HTTP 403.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="load_balancer_id=ocid1.loadbalancer.oc1.ap-seoul-1.example" \
  -var='protection_capabilities=[{"key":"9300000","version":1}]'
```
