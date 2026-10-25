# Public Safety basic example

Creates one Public Safety instance in an existing identity domain. This service has no Always Free shape.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="identity_domain_url=https://idcs-example.identity.oraclecloud.com" \
  -var="admin_identity_domain_user_id=ocid1.user.oc1..example"

```
