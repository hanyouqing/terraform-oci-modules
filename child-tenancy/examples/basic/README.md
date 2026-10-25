# Child tenancy basic example

Creates a governed child tenancy. Governance defaults to OPTED_IN, and no extra feature links are requested.

## Usage

```bash
terraform init
terraform plan \
  -var="tenancy_id=ocid1.tenancy.oc1..example" \
  -var="tenancy_name=labchild" \
  -var="home_region=us-ashburn-1" \
  -var="admin_email=child-admin@example.com"

```
