# File Storage basic example

Creates a file system, mount target, and export for one client CIDR. Root is squashed.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="availability_domain=ABcd:AP-SEOUL-1-AD-1" \
  -var="subnet_id=ocid1.subnet.oc1.ap-seoul-1.example" \
  -var="export_source_cidr=10.10.0.0/16"
```
