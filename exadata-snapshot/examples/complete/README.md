# Exadata snapshot complete example

Creates two snapshots of the same Exadata database so a change can be compared with the snapshot taken before it.

## Usage

```bash
terraform init
terraform plan \
  -var="database_id=ocid1.database.oc1.iad.example"
```
