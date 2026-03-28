# Production environment

Same layout as [development](../development/README.md). Use `env.hcl` with `environment = "production"` and your home region.

**Remote state bucket** name follows `terragrunt-state-<project>-production` (see root `terragrunt.hcl`). Create that bucket before first apply.

Review **production** overrides (e.g. `vcn` flow logs, `block-storage` backups) in each `terragrunt.hcl` compared to development.

For Always Free limits and required env vars, see [terragrunt README](../../README.md) and [development README](../development/README.md).
