output "bucket_names" {
  description = "Names of the buckets"
  value       = { for k, v in oci_objectstorage_bucket.this : k => v.name }
}

output "bucket_namespaces" {
  description = "Namespaces of the buckets"
  value       = { for k, v in oci_objectstorage_bucket.this : k => v.namespace }
}

output "bucket_uris" {
  description = "URIs of the buckets (format: https://objectstorage.<region>.oraclecloud.com/n/<namespace>/b/<name>/o)"
  value       = { for k, v in oci_objectstorage_bucket.this : k => "https://objectstorage.${var.region}.oraclecloud.com/n/${v.namespace}/b/${v.name}/o" }
}

output "preauth_request_uris" {
  description = "URIs of the pre-authenticated requests"
  value       = { for k, v in oci_objectstorage_preauthrequest.this : k => v.full_path }
}

output "namespace" {
  description = "Object Storage namespace"
  value       = data.oci_objectstorage_namespace.this.namespace
}
