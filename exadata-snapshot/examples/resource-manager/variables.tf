variable "database_id" {
  type        = string
  description = "OCID of the Exadata database to snapshot."
}

variable "region" {
  type        = string
  description = "OCI region. Resource Manager fills this when the stack is created."
}
