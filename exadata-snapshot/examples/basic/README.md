# Exadata snapshot basic example

Creates one snapshot of an existing Exadata database. ExaDB-XS is not an Always Free service.

## Usage

```bash
terraform init
terraform plan \
  -var="database_id=ocid1.database.oc1.iad.example"
```
