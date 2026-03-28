# NoSQL Database Complete Example

This example demonstrates a production-ready NoSQL Database setup with multiple tables, indexes, and capacity modes.

## Features

- 3 tables (users, events, sessions) — fits within Always Free tier
- Multiple index types: simple, composite, and JSON path indexes
- Both PROVISIONED and ON_DEMAND capacity modes
- Auto-reclaimable table for session data
- Comprehensive tagging

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## Tables

| Table | Schema | Capacity | Storage |
|-------|--------|----------|---------|
| users | id, username, email, profile (JSON) | PROVISIONED (50/50) | 25 GB |
| events | event_id, user_id, event_type, payload (JSON) | PROVISIONED (50/50) | 25 GB |
| sessions | session_id, user_id, data (JSON), expires_at | ON_DEMAND | 10 GB |

## Indexes

| Index | Table | Columns | Type |
|-------|-------|---------|------|
| idx_users_email | users | email | Simple |
| idx_events_user_type | events | user_id, event_type | Composite |
| idx_users_profile_city | users | profile.city | JSON path |
| idx_sessions_user | sessions | user_id | Simple |

## Production Considerations

- Monitor read/write unit consumption to stay within limits
- Use PROVISIONED mode for predictable workloads
- Use ON_DEMAND mode for bursty workloads (like sessions)
- Enable auto-reclaimable for temporary data tables
- Add JSON indexes for frequently queried JSON fields
