output "cluster_id" {
  description = "OCID of the OpenSearch cluster."
  value       = oci_opensearch_opensearch_cluster.this.id
}

output "fqdn" {
  description = "API fully qualified domain name of the OpenSearch cluster."
  value       = oci_opensearch_opensearch_cluster.this.fqdn
}

output "opendashboard_private_ip" {
  description = "Private IP of OpenSearch Dashboards."
  value       = oci_opensearch_opensearch_cluster.this.opendashboard_private_ip
}
