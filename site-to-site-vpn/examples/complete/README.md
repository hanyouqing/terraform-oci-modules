# Site-to-Site VPN Complete Example

This example demonstrates a multi-site VPN setup with primary and disaster recovery connections.

## Features

- 2 CPE objects (primary site + DR site)
- 2 IPSec connections (4 redundant tunnels total)
- Separate static routes per site
- Comprehensive tagging

## Architecture

```
On-Premises (Primary)                    OCI VCN
  10.0.0.0/16          ┌──── Tunnel 1 ────┐
  CPE (203.0.113.1) ───┤                  ├─── DRG ─── VCN
                        └──── Tunnel 2 ────┘

On-Premises (DR)
  172.16.0.0/16         ┌──── Tunnel 1 ────┐
  CPE (198.51.100.1) ──┤                  ├─── DRG ─── VCN
                        └──── Tunnel 2 ────┘
```

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="drg_id=ocid1.drg.oc1..xxxxx" \
  -var="primary_cpe_ip=203.0.113.1" \
  -var="dr_cpe_ip=198.51.100.1"
terraform apply
```

## Production Considerations

- Configure BGP routing for automatic failover (via tunnel management)
- Use IKEv2 for stronger security
- Monitor tunnel status with OCI Monitoring alarms
- Test failover by shutting down one tunnel at a time
- Document shared secrets securely (use Vault module)
