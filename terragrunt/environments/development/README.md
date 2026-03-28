# Development environment (Always Free)

This folder is the **out-of-the-box** Terragrunt stack for Always Free OCI resources. Edit `env.hcl` (region, `project`, optional `ad_index`) before applying.

## Before first apply

1. **Auth:** `oci setup config` or `OCI_CLI_*` env vars (see [terragrunt README](../../README.md)).
2. **Identity:** `TF_VAR_compartment_id`, `TF_VAR_tenancy_ocid`.
3. **Availability domain** (required for VCN subnets, compute, MySQL, load balancer, bastion, block volumes):  
   `export TF_VAR_availability_domain="<your-ad-name>"` (e.g. `UocI:PHX-AD-1` style; use Console **Identity → Availability Domains** or `oci iam availability-domain list` with your tenancy compartment)
4. **SSH** (before compute): `TF_VAR_ssh_public_keys`.
5. **Passwords** (before databases): `TF_VAR_adb_admin_password`, `TF_VAR_mysql_admin_password`.
6. **Notifications / monitoring:** `TF_VAR_alert_email` (used by notifications + monitoring alarm).
7. **Email delivery:** `TF_VAR_sender_email` (verified or test sender per OCI rules).
8. **Remote state:** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `TG_OCI_NAMESPACE`, and create the state bucket once (see [terragrunt README](../../README.md)).

## Apply order

`terragrunt run-all apply` resolves dependencies automatically. Manual order if needed:

1. `vcn`
2. `notifications` (before `monitoring`)
3. `compute` (before `block-storage`)
4. Independent in any order after VCN where needed: `autonomous-database`, `object-storage`, `vault`, `logging`, `email-delivery`, `mysql`, `load-balancer`, `bastion`
5. `block-storage` after `compute`
6. `monitoring` after `notifications`

## Uniqueness

Change `project` in `env.hcl` so **object storage bucket names** and other display names stay unique in your tenancy/namespace.
