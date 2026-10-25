# -----------------------------------------------------------------------------
# Optional: import a pre-existing bucket (e.g. Terraform remote state bucket)
# -----------------------------------------------------------------------------
# This file is documentation only (no active blocks). Uncomment one approach when
# you need to adopt a bucket that was created outside this module.
#
# Resource address when this module is the Terraform **root** (e.g. Terragrunt with
# `terraform.source` pointing here):
#   oci_objectstorage_bucket.this["<bucket_key>"]
# Terragrunt example: bucket_key = basename of the stack directory (e.g. object-storage).
#
# If you wrap this module, prefix with your module label:
#   module.<label>.oci_objectstorage_bucket.this["<bucket_key>"]
#
# `<bucket_key>` must match a key in `var.buckets`. This repo’s Terragrunt stack uses the
# stack directory name (e.g. `object-storage`) as the key for the state bucket.
#
# Remote state bootstrap: Terraform does **not** create the backend bucket. Create it
# once (Console or `oci os bucket create`), configure the backend, run `init`, then import.
#
# Use the **composite** import ID (Oracle provider). Do **not** use the bucket OCID alone
# or refresh can fail with NamespaceName / nil pointer:
#   n/<namespaceName>/b/<bucketName>
#
# Set an explicit `namespace` in `var.buckets` for that bucket (or rely on the module’s
# namespace data source) before importing.
#
# --- Terraform 1.5+ (uncomment, run plan/apply once, then remove or re-comment) ----------
#
#import {
#  to = oci_objectstorage_bucket.this["object-storage"]
#  id = "n/<namespace>/b/<bucket_name>"
#}
#
# --- CLI --------------------------------------------------------------------------------
#
# terraform import 'oci_objectstorage_bucket.this["object-storage"]' 'n/<namespace>/b/<bucket_name>'
#
# Terragrunt:
#   terragrunt run -- import 'oci_objectstorage_bucket.this["object-storage"]' 'n/<namespace>/b/<bucket_name>'
