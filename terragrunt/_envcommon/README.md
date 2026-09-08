# Shared module defaults

Each `*.hcl` file here is included by `<account>/<region>/<env>/<module>/terragrunt.hcl` with `merge_strategy = "deep"`.

## Config layers

Each file reads two config layers via `find_in_parent_folders()`:

| File | Provides |
|------|----------|
| `region.hcl` | `region` |
| `env.hcl` | `environment`, `project`, `ad_index` |

Account-level values (`compartment_id`, `tenancy_ocid`, `freeform_tags`) are injected by the root `root.hcl` shared inputs — they are NOT repeated here.

## `terraform.source`

Each file points at the **local workspace** module path
(`${dirname(find_in_parent_folders("root.hcl"))}/../<module>`) so edits apply before push.
For published stacks, pin a git ref instead, e.g.
`git::https://github.com/hanyouqing/terraform-oci-modules.git//vcn?ref=vX.Y.Z`.

## `ad_index`

Optional key in `env.hcl`. Exposed as `local.ad_index` for AZ-aware resources (compute, block-storage, MySQL).
