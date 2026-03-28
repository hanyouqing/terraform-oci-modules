# Certificates Complete Example

This example demonstrates a production-ready PKI setup with root CA, subordinate CA, and multiple certificate types.

## Features

- Root CA with maximum validity rules
- Subordinate (issuing) CA for leaf certificates
- Web server certificate with wildcard SANs
- API server certificate
- Client certificate for mutual TLS (mTLS)
- Configurable organization and domain names

## Usage

First, create a Vault + KMS key and the root CA. Then use the root CA OCID for the subordinate CA:

```bash
terraform init

# Step 1: Plan with your KMS key and root CA
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="kms_key_id=ocid1.key.oc1..xxxxx" \
  -var="root_ca_id=ocid1.certificateauthority.oc1..xxxxx" \
  -var="web_server_cn=app.example.com"

terraform apply
```

## Architecture

```
Root CA (root-ca)
└── Issuing CA (issuing-ca)
    ├── web-server cert (TLS_SERVER_OR_CLIENT)
    │   └── SANs: app.example.com, *.app.example.com
    ├── api-server cert (TLS_SERVER)
    │   └── SANs: api.app.example.com
    └── client-cert (TLS_CLIENT)
        └── For mutual TLS authentication
```

## Production Considerations

- Keep root CA offline; use subordinate CAs for daily issuance
- Set `leaf_certificate_max_validity_duration` to enforce rotation
- Use SANs for multi-domain certificates
- Monitor certificate expiry with OCI Monitoring
- Use separate CAs per environment for isolation
