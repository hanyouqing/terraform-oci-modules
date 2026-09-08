# Edge-public VCN example

Minimal public-edge topology: Internet Gateway, one regional public subnet,
configurable security-list ingress (HTTPS 443 + optional SSH CIDRs), and an
optional NSG for attaching to compute instances.

## Usage

```hcl
module "vcn" {
  source = "../../"
  # see main.tf in this directory
}
```

Provide `compartment_id` and `tenancy_ocid`. Leave `ssh_allow_cidrs` empty to
omit SSH ingress (recommended for locked-down edges).

This example is application-agnostic: pass your own ports/CIDRs; do not embed
product bootstrap into the shared module.
