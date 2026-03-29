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

## Cost Estimate

The following cost estimates are based on typical configurations and OCI standard pricing. Actual costs may vary based on region, usage patterns, and data transfer volumes.

### Always Free Tier

The following compute resources are **free** within Always Free tier limits:
- **VM.Standard.E2.1.Micro**: Up to 2 instances (AMD processor, 1/8 OCPU, 1 GB memory)
- **VM.Standard.A1.Flex**: Up to 4 OCPUs and 24 GB memory total (Arm processor)
- **Boot Volumes**: Included in Always Free (up to 200 GB total including block volumes)
- **Public IP Addresses**: Free when attached to Always Free instances

### Cost Breakdown (Beyond Always Free)

| Resource | Configuration | Estimated Cost (USD/month) |
|----------|--------------|---------------------------|
| **Compute Instances** | | |
| VM.Standard.E2.1.Micro | 1 instance (beyond Always Free) | ~**$5-7** |
| VM.Standard.A1.Flex (2 OCPUs, 12 GB) | 1 instance (beyond Always Free) | ~**$15-20** |
| VM.Standard.A1.Flex (4 OCPUs, 24 GB) | 1 instance (beyond Always Free) | ~**$30-40** |
| **Block Storage** | | |
| Boot Volume (50 GB) | Standard performance | ~**$2-3** |
| Block Volume (50 GB) | Standard performance, 10 VPUs/GB | ~**$2-3** |
| Block Volume (100 GB) | Standard performance, 10 VPUs/GB | ~**$4-5** |
| Block Volume Backup | 50 GB backup, 1 backup/month | ~**$1-2** |
| **Networking** | | |
| Public IP Address | 1 static public IP | **$0** (Free) |
| Data Transfer Out | 100 GB/month | ~**$9-10** |
| **Total (1 E2.1.Micro + 50 GB storage)** | Basic setup beyond Always Free | **~$18-25/month** |
| **Total (1 A1.Flex 2 OCPUs + 100 GB storage)** | Arm instance setup | **~$30-45/month** |

> **Notes:**
> - Costs are estimates based on Asia Pacific (Seoul) region pricing
> - Always Free tier includes 2 E2.1.Micro instances or up to 4 OCPUs A1.Flex
> - Block storage costs include both boot and data volumes
> - Data transfer costs apply to outbound internet traffic
> - Backup costs depend on backup frequency and retention
> - To minimize costs, use Always Free shapes when possible, and optimize block volume sizes

### Cost Optimization Tips

1. **Use Always Free shapes** (E2.1.Micro or A1.Flex) when possible
2. **Right-size block volumes** to match actual storage needs
3. **Use lower VPU settings** for non-performance-critical workloads
4. **Optimize backup policies** to reduce backup storage costs
5. **Monitor data transfer** and use Service Gateway for OCI service access (free)

## Examples

See the [examples](../examples/compute/) directory for complete examples.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 7.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_instance.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_volume.block](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_volume) | resource |
| [oci_core_volume_attachment.block](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_volume_attachment) | resource |
| [oci_core_images.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether to assign a public IP address | `bool` | `true` | no |
| <a name="input_availability_domain"></a> [availability\_domain](#input\_availability\_domain) | Availability domain for the instance. If not specified, will be distributed across ADs | `string` | `null` | no |
| <a name="input_block_volumes"></a> [block\_volumes](#input\_block\_volumes) | Map of block volumes to create and attach | <pre>map(object({<br/>    display_name         = string<br/>    size_in_gbs          = number<br/>    availability_domain  = optional(string, null)<br/>    instance_index       = number<br/>    device               = optional(string, null)<br/>    vpus_per_gb          = optional(string, "10")<br/>    is_auto_tune_enabled = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_boot_volume_size_in_gbs"></a> [boot\_volume\_size\_in\_gbs](#input\_boot\_volume\_size\_in\_gbs) | Size of the boot volume in GBs | `number` | `50` | no |
| <a name="input_boot_volume_vpus_per_gb"></a> [boot\_volume\_vpus\_per\_gb](#input\_boot\_volume\_vpus\_per\_gb) | VPUs per GB for the boot volume | `string` | `"10"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment where the compute instance will be created | `string` | n/a | yes |
| <a name="input_create_boot_volume"></a> [create\_boot\_volume](#input\_create\_boot\_volume) | Whether to create a separate boot volume | `bool` | `false` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags to apply to all resources (oci\_core\_instance expects map(string)) | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the compute instance(s) | `string` | `"compute-instance"` | no |
| <a name="input_enable_management_agent"></a> [enable\_management\_agent](#input\_enable\_management\_agent) | Enable OCI management agent | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable OCI monitoring agent | `bool` | `true` | no |
| <a name="input_enable_pv_encryption_in_transit"></a> [enable\_pv\_encryption\_in\_transit](#input\_enable\_pv\_encryption\_in\_transit) | Enable encryption in transit for paravirtualized boot volumes | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging | `string` | `"development"` | no |
| <a name="input_flexible_shapes"></a> [flexible\_shapes](#input\_flexible\_shapes) | List of shapes that require ocpus/memory\_in\_gbs (e.g. VM.Standard.A1.Flex, VM.Standard.E3.Flex) | `list(string)` | <pre>[<br/>  "VM.Standard.A1.Flex",<br/>  "VM.Standard.E3.Flex",<br/>  "VM.Standard.E4.Flex"<br/>]</pre> | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_hostname_label"></a> [hostname\_label](#input\_hostname\_label) | Hostname label for the instance | `string` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | OCID of the image to use. If not specified, will use the latest image for the specified OS | `string` | `null` | no |
| <a name="input_image_operating_system"></a> [image\_operating\_system](#input\_image\_operating\_system) | Operating system for the image (e.g., Oracle Linux, Ubuntu) | `string` | `"Oracle Linux"` | no |
| <a name="input_image_operating_system_version"></a> [image\_operating\_system\_version](#input\_image\_operating\_system\_version) | Operating system version for the image | `string` | `null` | no |
| <a name="input_image_sort_by"></a> [image\_sort\_by](#input\_image\_sort\_by) | Sort order for image selection (TIMECREATED, DISPLAYNAME) | `string` | `"TIMECREATED"` | no |
| <a name="input_image_sort_order"></a> [image\_sort\_order](#input\_image\_sort\_order) | Sort direction for image selection (ASC, DESC) | `string` | `"DESC"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of compute instances to create | `number` | `1` | no |
| <a name="input_memory_in_gbs"></a> [memory\_in\_gbs](#input\_memory\_in\_gbs) | Memory in GBs for flexible shapes (e.g. VM.Standard.A1.Flex) | `number` | `6` | no |
| <a name="input_nsg_ids"></a> [nsg\_ids](#input\_nsg\_ids) | List of Network Security Group OCIDs to attach | `list(string)` | `[]` | no |
| <a name="input_ocpus"></a> [ocpus](#input\_ocpus) | Number of OCPUs for flexible shapes (e.g. VM.Standard.A1.Flex) | `number` | `1` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address for the instance | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for tagging | `string` | `"oci-modules"` | no |
| <a name="input_shape"></a> [shape](#input\_shape) | Shape of the compute instance (e.g. VM.Standard.E2.1.Micro, VM.Standard.A1.Flex, VM.Standard.E4.Flex) | `string` | `"VM.Standard.E2.1.Micro"` | no |
| <a name="input_skip_source_dest_check"></a> [skip\_source\_dest\_check](#input\_skip\_source\_dest\_check) | Whether to skip source/destination check | `bool` | `false` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | SSH public key(s) for the instance. Multiple keys should be newline separated. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | OCID of the subnet where the instance will be created | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of the tenancy | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data script to run on instance launch | `string` | `null` | no |
| <a name="input_vnic_display_name"></a> [vnic\_display\_name](#input\_vnic\_display\_name) | Display name for the VNIC | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_block_volume_attachment_ids"></a> [block\_volume\_attachment\_ids](#output\_block\_volume\_attachment\_ids) | OCIDs of the block volume attachments |
| <a name="output_block_volume_ids"></a> [block\_volume\_ids](#output\_block\_volume\_ids) | OCIDs of the block volumes |
| <a name="output_boot_volume_ids"></a> [boot\_volume\_ids](#output\_boot\_volume\_ids) | OCIDs of the boot volumes |
| <a name="output_instance_availability_domains"></a> [instance\_availability\_domains](#output\_instance\_availability\_domains) | Availability domains of the compute instances |
| <a name="output_instance_display_names"></a> [instance\_display\_names](#output\_instance\_display\_names) | Display names of the compute instances |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | OCIDs of the compute instances |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | Private IP addresses of the compute instances |
| <a name="output_instance_public_ips"></a> [instance\_public\_ips](#output\_instance\_public\_ips) | Public IP addresses of the compute instances |
| <a name="output_zzz_reminders"></a> [zzz\_reminders](#output\_zzz\_reminders) | Important reminders and next steps for Compute module |
<!-- END_TF_DOCS -->
