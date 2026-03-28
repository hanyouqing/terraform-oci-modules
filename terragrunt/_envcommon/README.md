# Shared module defaults

Each `*.hcl` file here is included by `environments/<env>/<module>/terragrunt.hcl` with `merge_strategy = "deep"`.

## Locals block (repeated in every file)

Terragrunt does **not** merge `locals` from the root `terragrunt.hcl` into these partial configs, so each file reads `env.hcl` and sets `project`, `env`, `region`, and `ad_index`. `find_in_parent_folders("env.hcl")` is still resolved from the **leaf** stack directory (e.g. `environments/development/vcn/`), not from this folder.

## `terraform.source`

Each file uses a **literal** Git module source so configs are copy-paste friendly, e.g. `git::https://github.com/hanyouqing/terraform-oci-modules.git//vcn`. To use a local clone, set `terraform { source = "..." }` in the leaf `terragrunt.hcl` for that stack.

## Root vs `_envcommon`

The root `terragrunt.hcl` supplies shared **inputs** merged into every stack: `project`, `environment`, and default `freeform_tags`. Per-module inputs and `terraform.source` are defined here.

## `ad_index`

Optional key in `env.hcl` (see `environments/*/env.hcl`). Exposed as `local.ad_index` for overrides or future use in leaf `terragrunt.hcl` inputs.
