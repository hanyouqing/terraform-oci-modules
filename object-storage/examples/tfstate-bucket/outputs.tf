output "bucket_names" {
  description = "Created bucket names"
  value       = module.object_storage.bucket_names
}

output "namespace" {
  description = "Object Storage namespace"
  value       = module.object_storage.namespace
}

output "bucket_uris" {
  description = "Bucket URIs"
  value       = module.object_storage.bucket_uris
}
