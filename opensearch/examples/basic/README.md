# OpenSearch basic example

Creates a one-node-per-role cluster with security enforced and remote reindex left off. Node sizes match the provider's remote-reindex example and are billed. OpenSearch has no Always Free tier.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="vcn_id=ocid1.vcn.oc1.iad.example" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="security_master_user_password_hash=YOUR_OPENSEARCH_HASH"
```
