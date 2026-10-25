# OKE

Creates one enhanced OKE cluster with a private API endpoint and VCN-native pod networking. Dashboard and Tiller stay off. Node pools are optional, so the basic example creates the control plane only.

OKE is not an Always Free service. Confirm `kubernetes_version` and the worker image in the target region before apply. The seven solution stacks under `docs/oci-solutions-architect/examples` do not instantiate this module.

## Usage

```hcl
module "oke" {
  source = "../oke"

  compartment_id     = var.compartment_id
  name               = "app"
  kubernetes_version = "v1.33.1"
  vcn_id             = var.vcn_id
  endpoint_subnet_id = var.api_subnet_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 9.11 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_oci"></a> [oci](#provider\_oci) | ~> 9.11 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [oci_containerengine_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_cluster) | resource |
| [oci_containerengine_node_pool.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | OKE cluster type. ENHANCED\_CLUSTER is the current cluster type. | `string` | `"ENHANCED_CLUSTER"` | no |
| <a name="input_cni_type"></a> [cni\_type](#input\_cni\_type) | Pod networking. OCI\_VCN\_IP\_NATIVE places pod IPs in subnet CIDRs. | `string` | `"OCI_VCN_IP_NATIVE"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCID of the compartment that owns the cluster and node pools. | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Defined tags applied to the cluster and node pools. | `map(string)` | `{}` | no |
| <a name="input_endpoint_nsg_ids"></a> [endpoint\_nsg\_ids](#input\_endpoint\_nsg\_ids) | NSG OCIDs for the Kubernetes API endpoint. | `set(string)` | `[]` | no |
| <a name="input_endpoint_public_ip_enabled"></a> [endpoint\_public\_ip\_enabled](#input\_endpoint\_public\_ip\_enabled) | Assign a public IP to the Kubernetes API endpoint. Leave false so the API is reachable only from the VCN, a bastion, or a private path. | `bool` | `false` | no |
| <a name="input_endpoint_subnet_id"></a> [endpoint\_subnet\_id](#input\_endpoint\_subnet\_id) | OCID of the subnet for the Kubernetes API endpoint. Use a private subnet. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name recorded on freeform tags. | `string` | `"development"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Freeform tags merged onto module-managed tags. | `map(string)` | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Vault key OCID for Kubernetes secrets encryption. Null uses Oracle-managed encryption. | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version supported in the target region, for example v1.33.1. There is no default, because supported versions change by region. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the OKE cluster. | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Worker node pools. Empty creates the control plane only. image\_id must be an OKE worker image for the region. | <pre>map(object({<br/>    node_shape          = string<br/>    size                = number<br/>    availability_domain = string<br/>    subnet_id           = string<br/>    image_id            = string<br/>    ocpus               = number<br/>    memory_in_gbs       = number<br/>    ssh_public_key      = optional(string)<br/>    nsg_ids             = optional(set(string), [])<br/>    pod_subnet_ids      = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_pods_cidr"></a> [pods\_cidr](#input\_pods\_cidr) | Pod CIDR used only with FLANNEL\_OVERLAY. Leave null for OCI\_VCN\_IP\_NATIVE. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name recorded on freeform tags. | `string` | `"oci-modules"` | no |
| <a name="input_service_lb_subnet_ids"></a> [service\_lb\_subnet\_ids](#input\_service\_lb\_subnet\_ids) | Subnet OCIDs where Kubernetes LoadBalancer services place OCI load balancers. | `list(string)` | `[]` | no |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | CIDR for Kubernetes services. Must not overlap the VCN. | `string` | `"10.96.0.0/16"` | no |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | OCID of the VCN for the cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | OCID of the OKE cluster. |
| <a name="output_cluster_kubernetes_version"></a> [cluster\_kubernetes\_version](#output\_cluster\_kubernetes\_version) | Kubernetes version of the cluster. |
| <a name="output_node_pool_ids"></a> [node\_pool\_ids](#output\_node\_pool\_ids) | OCIDs of the node pools, keyed by pool name. |
<!-- END_TF_DOCS -->
