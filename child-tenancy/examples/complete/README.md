# Child tenancy complete example

Creates a governed child tenancy with an explicit administrator policy name and optional extra organization links.

## Usage

```bash
terraform init
terraform plan \
  -var="tenancy_id=ocid1.tenancy.oc1..example" \
  -var="tenancy_name=labchild" \
  -var="home_region=us-ashburn-1" \
  -var="admin_email=child-admin@example.com"

```
