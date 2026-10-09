# Status

- [x] Provider bump to `~> 9.9` across modules and examples (2026-10-09 weekly audit; latest registry 9.9.0)
- [x] Terraform required_version floor `>= 1.16.0`; CI / `.terraform-version` pin `1.16.5`
- [x] Default tags: `ManagedBy = "Terraform"` plus `Project` / `Environment` on tagged resources
- [x] `project` and `environment` inputs require non-empty validation
- [x] Phase 1: vcn / compute / object-storage (+ edge/tfstate examples, Terragrunt alignment)
- [x] Phase 2: remaining modules quality pass
- [x] Production pre-release review (pass 1–2): network hardening, sensitive outputs, private defaults
- [x] Production pre-release review (pass 3): Always Free ADB ACL-only, credentials user_id schema, LB listener schema, state bucket docs, fail-closed email/APM/certs

## Follow-ups (optional)

- Existing environments that used `oci_core_route_table_attachment` will see those resources destroyed and `route_table_id` set on subnets (expected one-time state migration)
- Pin git `?ref=` in `_envcommon` when cutting a release tag
- Before apply set as needed: `TF_VAR_bastion_allowed_cidr`, `TF_VAR_adb_allowed_cidr` (required for Free ADB), `TF_VAR_ssh_public_keys`, `TF_VAR_adb_admin_password`, `TF_VAR_mysql_admin_password`, `TF_VAR_user_ocid`, `TF_VAR_cpe_ip_address`, `TF_VAR_alert_email`, `TF_VAR_sender_email`, `TF_VAR_cert_common_name`, `TF_VAR_apm_health_url`
- State bucket name is `<project>-tfstate` (e.g. `oci-modules-tfstate`), not `<project>-<account>-tfstate`
