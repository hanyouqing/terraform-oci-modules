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

output "zzz_reminders" {
  description = "Important reminders and next steps for Object Storage module"
  value = {
    next_steps = [
      "Verify bucket access policies and ensure appropriate permissions",
      "Test object upload/download operations",
      "Review lifecycle policies to optimize storage costs",
      "Configure pre-authenticated requests if needed for temporary access",
      "Monitor storage usage to stay within Always Free tier (20 GB)"
    ]
    verification = [
      "List buckets: oci os bucket list --compartment-id ${var.compartment_id} --namespace-name ${data.oci_objectstorage_namespace.this.namespace}",
      "Check bucket details: oci os bucket get --bucket-name ${length(oci_objectstorage_bucket.this) > 0 ? values(oci_objectstorage_bucket.this)[0].name : "N/A"} --namespace-name ${data.oci_objectstorage_namespace.this.namespace}",
      "List objects: oci os object list --bucket-name ${length(oci_objectstorage_bucket.this) > 0 ? values(oci_objectstorage_bucket.this)[0].name : "N/A"} --namespace-name ${data.oci_objectstorage_namespace.this.namespace}"
    ]
    security_notes = [
      "Review bucket access type (NoPublicAccess recommended)",
      "Use IAM policies for fine-grained access control",
      "Enable versioning for critical data",
      "Review and restrict pre-authenticated request permissions",
      "Monitor access logs for suspicious activity"
    ]
    cost_optimization = [
      "Always Free tier: 20 GB storage + 50,000 API requests",
      "Use lifecycle policies to transition to Infrequent Access or Archive tiers",
      "Optimize API requests by batching operations",
      "Use Service Gateway for OCI service access (free, no data transfer charges)",
      "Archive old data to reduce storage costs"
    ]
    important_resources = {
      bucket_count       = length(oci_objectstorage_bucket.this)
      namespace          = data.oci_objectstorage_namespace.this.namespace
      preauth_count      = length(oci_objectstorage_preauthrequest.this)
      lifecycle_policies = length(var.lifecycle_policies)
    }
    access_info = length(oci_objectstorage_bucket.this) > 0 ? {
      bucket_uri     = "https://objectstorage.${var.region}.oraclecloud.com/n/${data.oci_objectstorage_namespace.this.namespace}/b/${values(oci_objectstorage_bucket.this)[0].name}/o"
      oci_cli_upload = "oci os object put --bucket-name ${values(oci_objectstorage_bucket.this)[0].name} --namespace-name ${data.oci_objectstorage_namespace.this.namespace} --file <file>"
    } : null
  }
}
