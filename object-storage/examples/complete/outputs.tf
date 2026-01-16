output "bucket_names" {
  description = "Bucket names"
  value       = module.object_storage.bucket_names
}

output "bucket_namespaces" {
  description = "Bucket namespaces"
  value       = module.object_storage.bucket_namespaces
}

output "bucket_uris" {
  description = "Bucket URIs"
  value       = module.object_storage.bucket_uris
}

output "preauth_request_uris" {
  description = "Pre-authenticated request URIs"
  value       = module.object_storage.preauth_request_uris
}

output "namespace" {
  description = "Object Storage namespace"
  value       = module.object_storage.namespace
}
