output "gateway_id" {
  description = "OCID of the API Gateway."
  value       = oci_apigateway_gateway.this.id
}

output "hostname" {
  description = "Hostname of the gateway."
  value       = oci_apigateway_gateway.this.hostname
}

output "deployment_ids" {
  description = "Deployment OCIDs keyed by display name."
  value       = { for name, dep in oci_apigateway_deployment.this : name => dep.id }
}

output "deployment_endpoints" {
  description = "Deployment endpoint URLs keyed by display name."
  value       = { for name, dep in oci_apigateway_deployment.this : name => dep.endpoint }
}
