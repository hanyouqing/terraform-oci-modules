# OKE basic example

Creates the control plane only. The API endpoint stays private. Add node pools in the complete example after choosing a worker image for the region.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="kubernetes_version=v1.33.1" \
  -var="vcn_id=ocid1.vcn.oc1.ap-seoul-1.example" \
  -var="endpoint_subnet_id=ocid1.subnet.oc1.ap-seoul-1.example"
```
