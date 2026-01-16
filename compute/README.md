# Compute Module

This module creates Always Free compute instances in Oracle Cloud Infrastructure. It supports both VM.Standard.E2.1.Micro (AMD) and VM.Standard.A1.Flex (Arm) shapes.

## Features

- Support for Always Free shapes:
  - VM.Standard.E2.1.Micro (AMD processor)
  - VM.Standard.A1.Flex (Arm processor, 1-4 OCPUs, 6-24 GB memory)
- Automatic image selection based on OS
- Boot volume management
- Block volume attachment
- Public/private IP assignment
- Network Security Group support
- User data scripts
- Monitoring and management agent configuration
- Comprehensive tagging support

## Always Free Limits

- **VM.Standard.E2.1.Micro**: Up to 2 instances
- **VM.Standard.A1.Flex**: Up to 4 OCPUs and 24 GB memory total
- **Total Block Storage**: 200 GB (boot + block volumes)
- **Backups**: 5 volume backups

## Usage

### Basic Example

```hcl
module "compute" {
  source = "../compute"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  subnet_id      = module.vcn.public_subnet_ids["public-subnet-1"]

  shape              = "VM.Standard.E2.1.Micro"
  instance_count     = 1
  ssh_public_keys    = file("~/.ssh/id_rsa.pub")

  project     = "my-project"
  environment = "production"
}
```

### A1 Flex Example

```hcl
module "compute_a1" {
  source = "../compute"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
  subnet_id      = module.vcn.public_subnet_ids["public-subnet-1"]

  shape          = "VM.Standard.A1.Flex"
  ocpus          = 2
  memory_in_gbs  = 12
  instance_count = 1
  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  block_volumes = {
    data-volume = {
      display_name        = "data-volume"
      size_in_gbs         = 50
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      instance_index      = 0
      device              = "/dev/oracleoci/oraclevdb"
      vpus_per_gb         = "10"
      is_auto_tune_enabled = false
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| oci | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| oci | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | OCID of the compartment where the compute instance will be created | `string` | n/a | yes |
| tenancy_ocid | OCID of the tenancy | `string` | n/a | yes |
| subnet_id | OCID of the subnet where the instance will be created | `string` | n/a | yes |
| ssh_public_keys | SSH public key(s) for the instance | `string` | n/a | yes |
| instance_count | Number of compute instances to create | `number` | `1` | no |
| shape | Shape of the compute instance | `string` | `"VM.Standard.E2.1.Micro"` | no |
| ocpus | Number of OCPUs for VM.Standard.A1.Flex shape | `number` | `1` | no |
| memory_in_gbs | Memory in GBs for VM.Standard.A1.Flex shape | `number` | `6` | no |
| availability_domain | Availability domain for the instance | `string` | `null` | no |
| display_name | Display name for the compute instance(s) | `string` | `"compute-instance"` | no |
| image_id | OCID of the image to use | `string` | `null` | no |
| image_operating_system | Operating system for the image | `string` | `"Oracle Linux"` | no |
| assign_public_ip | Whether to assign a public IP address | `bool` | `true` | no |
| block_volumes | Map of block volumes to create and attach | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | OCIDs of the compute instances |
| instance_private_ips | Private IP addresses of the compute instances |
| instance_public_ips | Public IP addresses of the compute instances |
| block_volume_ids | OCIDs of the block volumes |

## Examples

See the [examples](../examples/compute/) directory for complete examples.
