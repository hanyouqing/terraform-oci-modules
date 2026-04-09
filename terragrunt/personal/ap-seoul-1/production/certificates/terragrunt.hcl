include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/certificates.hcl"
  expose         = true
  merge_strategy = "deep"
}

dependency "vault" {
  config_path = "../vault"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    key_ids = { "ca-key" = "ocid1.key.oc1..mock" }
  }
}

inputs = {
  # Production: add certificates for web services
  certificates = {
    web-cert = {
      name        = "web-server-cert"
      ca_key      = "root-ca"
      common_name = "app.example.com"
      subject_alternative_names = [
        { type = "DNS", value = "app.example.com" },
        { type = "DNS", value = "*.app.example.com" }
      ]
    }
  }
}
