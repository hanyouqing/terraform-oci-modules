# OCI Cache complete example

Creates a three-node non-sharded cluster and attaches one IAM user. The user ACL allows read and write only on keys that start with `app:`. Clients use TLS and a short-lived IAM token. The token is not created by this example.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1.ap-seoul-1.example" \
  -var='nsg_ids=["ocid1.networksecuritygroup.oc1.ap-seoul-1.example"]'
```
