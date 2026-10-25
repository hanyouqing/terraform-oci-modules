# File Storage complete example

Adds a customer-managed key, a hostname label, and NSGs to the file system and mount target. The export still allows one client CIDR.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="availability_domain=ABcd:AP-SEOUL-1-AD-1" \
  -var="subnet_id=ocid1.subnet.oc1.ap-seoul-1.example" \
  -var="export_source_cidr=10.10.0.0/16" \
  -var="hostname_label=files" \
  -var="kms_key_id=ocid1.key.oc1.ap-seoul-1.example"
```
