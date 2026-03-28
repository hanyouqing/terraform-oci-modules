terraform {
  required_version = ">= 1.14.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.30"
    }
  }
}

module "nosql_database" {
  source = "../../"

  compartment_id = var.compartment_id

  tables = {
    # Table 1: Users — Always Free, PROVISIONED
    users = {
      name          = "users"
      ddl_statement = "CREATE TABLE users (id INTEGER, username STRING, email STRING, profile JSON, created_at TIMESTAMP(0), PRIMARY KEY (id))"

      max_read_units     = 50
      max_write_units    = 50
      max_storage_in_gbs = 25
      capacity_mode      = "PROVISIONED"
      freeform_tags      = { "Purpose" = "user-management" }
    }

    # Table 2: Events — Always Free, PROVISIONED
    events = {
      name          = "events"
      ddl_statement = "CREATE TABLE events (event_id STRING, user_id INTEGER, event_type STRING, payload JSON, created_at TIMESTAMP(3), PRIMARY KEY (event_id))"

      max_read_units     = 50
      max_write_units    = 50
      max_storage_in_gbs = 25
      capacity_mode      = "PROVISIONED"
      freeform_tags      = { "Purpose" = "event-tracking" }
    }

    # Table 3: Sessions — Always Free, ON_DEMAND, auto-reclaimable
    sessions = {
      name          = "sessions"
      ddl_statement = "CREATE TABLE sessions (session_id STRING, user_id INTEGER, data JSON, expires_at TIMESTAMP(0), PRIMARY KEY (session_id))"

      max_read_units      = 0
      max_write_units     = 0
      max_storage_in_gbs  = 10
      capacity_mode       = "ON_DEMAND"
      is_auto_reclaimable = true
      freeform_tags       = { "Purpose" = "session-store" }
    }
  }

  indexes = {
    # Simple column index
    users-email = {
      table_key = "users"
      name      = "idx_users_email"
      keys = [
        { column_name = "email" }
      ]
    }

    # Composite index
    events-user-type = {
      table_key = "events"
      name      = "idx_events_user_type"
      keys = [
        { column_name = "user_id" },
        { column_name = "event_type" }
      ]
    }

    # JSON path index
    users-profile-city = {
      table_key = "users"
      name      = "idx_users_profile_city"
      keys = [
        {
          column_name     = "profile"
          json_path       = "profile.city"
          json_field_type = "STRING"
        }
      ]
    }

    # Index on sessions for user lookup
    sessions-user = {
      table_key = "sessions"
      name      = "idx_sessions_user"
      keys = [
        { column_name = "user_id" }
      ]
    }
  }

  project     = var.project
  environment = var.environment

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
