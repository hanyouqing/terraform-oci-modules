# GoldenGate basic example

Creates a private PostgreSQL GoldenGate connection. The password is a Vault secret OCID.

Connection type and technology type must be a pair the GoldenGate service accepts in your region.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="host=10.50.2.10" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="password_secret_id=ocid1.vaultsecret.oc1.iad.example"
```
