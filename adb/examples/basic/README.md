# Autonomous Database Basic Example

This example creates a minimal Always Free Autonomous Database.

## Features

- Single Always Free Autonomous Database (1 OCPU, 20 GB)
- OLTP workload type
- Public access (whitelisted IPs)
- Suitable for Always Free tier

## Usage

Set the admin password only via environment or a secret store—never commit it. For example:

```bash
export TF_VAR_admin_password="$(openssl rand -base64 32)"   # or inject from CI / 1Password / Vault
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

When `TF_VAR_admin_password` is set, you do not need `-var="admin_password=..."`.

## Always Free Considerations

- 1 OCPU and 20 GB storage (Always Free limits)
- Free tier enabled
- Public endpoint (no private endpoint needed)
- Suitable for development/testing workloads
