# OpenSearch complete example

Creates the same small cluster as the basic example and trusts one remote endpoint for reindex. The CA bundle must already exist. The remote URL has to be https.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="vcn_id=ocid1.vcn.oc1.iad.example" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="security_master_user_password_hash=YOUR_OPENSEARCH_HASH" \
  -var="remote_ca_bundle_id=ocid1.cabundle.oc1..example" \
  -var="remote_endpoint=https://remote.example.com:9200"
```
