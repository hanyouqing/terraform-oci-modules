# Site-to-Site VPN Basic Example

This example creates a single Site-to-Site VPN connection with static routing.

## Features

- Single CPE object (on-premises VPN device)
- Single IPSec connection with 2 redundant tunnels
- Static routing to on-premises network (10.0.0.0/16)
- Suitable for development and testing

## Prerequisites

- A DRG (Dynamic Routing Gateway) — create one with the VCN module (`create_drg = true`)
- Public IP address of your on-premises VPN device

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="drg_id=ocid1.drg.oc1..xxxxx" \
  -var="cpe_ip_address=203.0.113.1"
terraform apply
```

## After Apply

1. Note the Oracle VPN endpoint IPs from the `tunnel_vpn_ips` output
2. Get shared secrets: `oci network ip-sec-tunnel list --ipsc-id <ipsec_id>`
3. Configure your on-premises CPE device with the VPN IPs and shared secrets
4. Verify tunnels are UP: `oci network ip-sec-tunnel list --ipsc-id <ipsec_id>`

## Always Free Considerations

- Up to 50 IPSec connections (this example creates 1)
- 2 redundant tunnels per connection (free)
- No per-connection charge; only data transfer costs apply
