output "bucket_names" {
  description = "Bucket names"
  value       = module.object_storage.bucket_names
}

output "bucket_uris" {
  description = "Bucket URIs"
  value       = module.object_storage.bucket_uris
}
