# Data Safe complete example

Enables Data Safe, creates a private endpoint, and registers Autonomous Database targets when passwords are supplied at apply time. Do not commit those passwords.

## Usage

```bash
terraform init
terraform plan \
  -var="tenancy_ocid=ocid1.tenancy.oc1..example" \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var='private_endpoint={"display_name":"data-safe","subnet_id":"ocid1.subnet.oc1.ap-seoul-1.example","vcn_id":"ocid1.vcn.oc1.ap-seoul-1.example"}'
```
