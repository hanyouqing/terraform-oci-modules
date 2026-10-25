# PostgreSQL basic example

Creates one flexible PostgreSQL node. The password stays in Vault. In-place major upgrades stay off, so a later `db_version` change replaces the system instead of upgrading it.

This shape is billed. OCI PostgreSQL has no Always Free tier.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="admin_password_secret_id=ocid1.vaultsecret.oc1.iad.example"
```
