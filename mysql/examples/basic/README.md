# MySQL HeatWave Basic Example

This example creates a minimal Always Free MySQL HeatWave system.

## Features

- Single-node MySQL HeatWave system using **`MySQL.Free`** shape (Always Free)
- 50 GB data storage (Always Free limit)
- Basic backup policy
- Suitable for Always Free tier

Do **not** use paid shapes (for example `MySQL.HeatWave.VM.Standard.E3.*`) in this example—they are not covered by Always Free.

## Usage

Set the database password only via environment or a secret store—never commit it. For example:

```bash
export TF_VAR_admin_password="$(openssl rand -base64 32)"   # or inject from CI / 1Password / Vault
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="tenancy_ocid=ocid1.tenancy.oc1..xxxxx" \
  -var="subnet_id=ocid1.subnet.oc1..xxxxx"
terraform apply
```

When `TF_VAR_admin_password` is set, you do not need `-var="admin_password=..."`.

## Always Free Considerations

- 50 GB data storage (Always Free limit)
- Single-node system
- 7-day backup retention
- Suitable for development/testing
