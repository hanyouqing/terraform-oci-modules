output "cluster_id" {
  description = "OCID of the OCI Cache cluster."
  value       = oci_redis_redis_cluster.this.id
}

output "primary_fqdn" {
  description = "Primary endpoint FQDN. Null on a sharded cluster."
  value       = oci_redis_redis_cluster.this.primary_fqdn
}

output "replicas_fqdn" {
  description = "Replica endpoint FQDN. Null on a sharded cluster."
  value       = oci_redis_redis_cluster.this.replicas_fqdn
}

output "discovery_fqdn" {
  description = "Discovery endpoint FQDN for a sharded cluster."
  value       = oci_redis_redis_cluster.this.discovery_fqdn
}

output "user_ids" {
  description = "OCIDs of the IAM OCI Cache users, keyed by user name."
  value       = { for name, user in oci_redis_oci_cache_user.this : name => user.id }
}
