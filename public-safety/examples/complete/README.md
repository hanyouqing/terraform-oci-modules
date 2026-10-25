# Public Safety complete example

Same instance as the basic example, with project, environment, and caller-supplied defined tags.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="identity_domain_url=https://idcs-example.identity.oraclecloud.com" \
  -var="admin_identity_domain_user_id=ocid1.user.oc1..example"

```
