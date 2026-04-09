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
  # Development: single Always Free table with auto-reclaimable
  tables = {
    app-data = {
      is_auto_reclaimable = true
    }
  }
}
