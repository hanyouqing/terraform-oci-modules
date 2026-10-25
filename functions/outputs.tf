output "application_id" {
  description = "OCID of the Functions application."
  value       = oci_functions_application.this.id
}

output "function_ids" {
  description = "Function OCIDs keyed by display name."
  value       = { for name, fn in oci_functions_function.this : name => fn.id }
}

output "invoke_endpoints" {
  description = "HTTPS invoke endpoints keyed by function display name."
  value       = { for name, fn in oci_functions_function.this : name => fn.invoke_endpoint }
}
