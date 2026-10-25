# WAF basic example

Creates the WAF policy and does not attach it to a load balancer. Request inspection stays off until protection capabilities are set.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example"
```
