# PostgreSQL complete example

Creates one flexible PostgreSQL node with customer-managed encryption, network security groups, and the provider 9.11 in-place upgrade path. After apply, raising `db_version` upgrades the system and runs `RUN_POST_UPGRADE_VACUUM`.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="admin_password_secret_id=ocid1.vaultsecret.oc1.iad.example"
```
