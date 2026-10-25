# Data Safe basic example

Enables Data Safe and creates no private endpoint and no target database. That keeps database passwords out of this example.

## Usage

```bash
terraform init
terraform plan \
  -var="tenancy_ocid=ocid1.tenancy.oc1..example"
```
