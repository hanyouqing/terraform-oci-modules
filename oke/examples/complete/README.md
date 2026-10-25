# OKE complete example

Creates a private enhanced cluster and the node pools you pass in. Use an OKE worker image and a pod subnet in the same VCN.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="kubernetes_version=v1.33.1" \
  -var="vcn_id=ocid1.vcn.oc1.ap-seoul-1.example" \
  -var="endpoint_subnet_id=ocid1.subnet.oc1.ap-seoul-1.example" \
  -var='node_pools={"workers":{"node_shape":"VM.Standard.E4.Flex","size":2,"availability_domain":"ABcd:AP-SEOUL-1-AD-1","subnet_id":"ocid1.subnet.oc1.ap-seoul-1.example","image_id":"ocid1.image.oc1.ap-seoul-1.example","ocpus":2,"memory_in_gbs":16,"pod_subnet_ids":["ocid1.subnet.oc1.ap-seoul-1.example"]}}'
```
