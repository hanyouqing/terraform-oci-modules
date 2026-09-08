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

locals {
  cert_cn = trimspace(get_env("TF_VAR_cert_common_name", ""))
}

# Fail-closed: no leaf certificates until TF_VAR_cert_common_name is set.
inputs = {
  certificates = local.cert_cn != "" ? {
    web-cert = {
      name        = "web-server-cert"
      ca_key      = "root-ca"
      common_name = local.cert_cn
      subject_alternative_names = [
        { type = "DNS", value = local.cert_cn },
        { type = "DNS", value = "*.${local.cert_cn}" }
      ]
    }
  } : {}
}
