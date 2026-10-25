resource "oci_golden_gate_connection" "this" {
  compartment_id  = var.compartment_id
  display_name    = var.display_name
  description     = var.description
  connection_type = var.connection_type
  technology_type = var.technology_type

  username          = var.username
  host              = var.host
  port              = var.port
  database_name     = var.database_name
  connection_string = var.connection_string
  subnet_id         = var.subnet_id
  nsg_ids           = length(var.nsg_ids) == 0 ? null : var.nsg_ids
  vault_id          = var.vault_id

  does_use_secret_ids = var.does_use_secret_ids
  password_secret_id  = var.password_secret_id

  # Release 12 connection fields added in provider 9.11.0.
  # Secrets are accepted only as Vault secret OCIDs.
  cluster_endpoint               = var.cluster_endpoint
  workspace_url                  = var.workspace_url
  rest_endpoint                  = var.rest_endpoint
  provider_id                    = var.provider_id
  submit_mode                    = var.submit_mode
  rpc_cipher                     = var.rpc_cipher
  tls_protocol                   = var.tls_protocol
  key_store_type                 = var.key_store_type
  trust_store_type               = var.trust_store_type
  auth_secret_secret_id          = var.auth_secret_secret_id
  auth_token_secret_id           = var.auth_token_secret_id
  rest_auth_secret_key_secret_id = var.rest_auth_secret_key_secret_id
  key_store_secret_id            = var.key_store_secret_id
  trust_store_secret_id          = var.trust_store_secret_id

  freeform_tags = merge(
    {
      "ManagedBy"   = "terraform"
      "Module"      = "github.com/hanyouqing/terraform-oci-modules/golden-gate"
      "Project"     = var.project
      "Environment" = var.environment
    },
    var.freeform_tags
  )

  defined_tags = var.defined_tags
}
