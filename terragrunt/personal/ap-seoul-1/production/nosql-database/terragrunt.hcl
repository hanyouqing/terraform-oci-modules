include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/nosql-database.hcl"
  expose         = true
  merge_strategy = "deep"
}

inputs = {
  # Production: higher throughput, no auto-reclaimable
  tables = {
    app-data = {
      max_read_units      = 200
      max_write_units     = 200
      is_auto_reclaimable = false
    }
  }
}
