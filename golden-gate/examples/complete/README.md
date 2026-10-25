# GoldenGate complete example

Creates a Release 12 connection using the fields added in provider 9.11.0. Tokens and key material stay in Vault. Set `connection_type` and `technology_type` to the pair for that source. Pass `deployment` to add a private deployment whose admin password is a Vault secret OCID.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="connection_type=DATABRICKS" \
  -var="technology_type=DATABRICKS" \
  -var="subnet_id=ocid1.subnet.oc1.iad.example" \
  -var="vault_id=ocid1.vault.oc1.iad.example" \
  -var="cluster_endpoint=https://dbc.example.com" \
  -var="workspace_url=https://dbc.example.com" \
  -var="rest_endpoint=https://dbc.example.com" \
  -var="provider_id=example" \
  -var="auth_token_secret_id=ocid1.vaultsecret.oc1.iad.example"
```
