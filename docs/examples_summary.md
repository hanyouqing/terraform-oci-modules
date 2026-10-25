# Examples Summary

## Solution architectures

Cross-module OCI Solutions Architect labs live in `docs/oci-solutions-architect/examples/`. The role analysis and 12-week plan are in `docs/oci-solutions-architect/`.

| Directory | What it deploys |
| --- | --- |
| `docs/oci-solutions-architect/examples/00-iac-lifecycle` | Private versioned state bucket and the delivery workflow |
| `docs/oci-solutions-architect/examples/01-secure-landing-zone` | Optional compartments and policies, VCN, vault, bastion, logging, alarms |
| `docs/oci-solutions-architect/examples/02-three-tier-application` | Load balancer, private compute, private Autonomous Database |
| `docs/oci-solutions-architect/examples/03-hybrid-site-to-site` | DRG, IPSec static routes, on-premises return route |
| `docs/oci-solutions-architect/examples/04-data-platform` | ATP, MySQL, NoSQL, block volume, archive lifecycle |
| `docs/oci-solutions-architect/examples/05-observability` | Logging, alarms, APM, notifications, email sender |
| `docs/oci-solutions-architect/examples/06-edge-certificates` | Internal CA, layer-7 and layer-4 listeners |

## Overview

All 13 modules now have both `basic` and `complete` examples:

### Basic Examples
- Optimized for Always Free tier resources
- Minimal configuration
- Cost-effective setup
- Suitable for development/testing

### Complete Examples
- Production-ready configurations
- All features enabled
- Comprehensive tagging
- Security best practices

## Modules with Examples

1. **VCN** - Virtual Cloud Network
2. **Compute** - Compute instances
3. **Block Storage** - Block volumes
4. **Object Storage** - Object Storage buckets
5. **Autonomous Database** - Oracle Autonomous Database
6. **MySQL** - MySQL HeatWave
7. **Load Balancer** - Load balancer
8. **Vault** - Vault and secrets
9. **Monitoring** - Monitoring alarms
10. **Notifications** - Notification Service
11. **Email Delivery** - Email Delivery
12. **Logging** - Logging service
13. **Bastion** - Bastion service

## Example Structure

Each example includes:
- `main.tf` - Main configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `README.md` - Usage documentation

## Usage

Navigate to any example directory and follow the README instructions:

```bash
cd vcn/examples/basic
terraform init
terraform plan
terraform apply
```
