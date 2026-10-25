# Status

- [x] Provider bump to `~> 9.11` across modules and examples
- [x] Phase 1: vcn / compute / object-storage (+ edge/tfstate examples, Terragrunt alignment)
- [x] Phase 2: remaining modules quality pass
- [x] Production pre-release review (pass 1–2): network hardening, sensitive outputs, private defaults
- [x] Production pre-release review (pass 3): Always Free ADB ACL-only, credentials user_id schema, LB listener schema, state bucket docs, fail-closed email/APM/certs

## Follow-ups (optional)

- Provider 9.11.0 modules: `public-safety`, `child-tenancy`, `exadata-snapshot`, `postgresql`, `opensearch`, `golden-gate`, `generative-ai`. Dynamic Resource VM and the Managed Kafka addon bugfix did not add a Terraform resource or argument, so they have no module. In-scope feature gaps that remain: MySQL HeatWave blue/green (`oci_mysql_blue_green_deployment`), NAT on DRG (`oci_core_drg_nat_policy`), block backup retention lock, customer-managed keys on block volumes, ADB maintenance window / customer-managed encryption, VCN subnet IPv6 CIDRs, ZPR `security_attributes`. See `docs/oci-solutions-architect/06-provider-and-practices.md`.

- Existing environments that used `oci_core_route_table_attachment` will see those resources destroyed and `route_table_id` set on subnets (expected one-time state migration)
- Pin git `?ref=` in `_envcommon` when cutting a release tag
- Before apply set as needed: `TF_VAR_bastion_allowed_cidr`, `TF_VAR_adb_allowed_cidr` (required for Free ADB), `TF_VAR_ssh_public_keys`, `TF_VAR_adb_admin_password`, `TF_VAR_mysql_admin_password`, `TF_VAR_user_ocid`, `TF_VAR_cpe_ip_address`, `TF_VAR_alert_email`, `TF_VAR_sender_email`, `TF_VAR_cert_common_name`, `TF_VAR_apm_health_url`
- State bucket name is `<project>-tfstate` (e.g. `oci-modules-tfstate`), not `<project>-<account>-tfstate`
