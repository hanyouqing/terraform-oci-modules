# OCI Cache basic example

Creates a one-node non-sharded cluster. A one-node cluster has no replica. Put it in a private subnet.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1.ap-seoul-1.example"
```
