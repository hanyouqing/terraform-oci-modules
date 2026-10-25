# Exadata complete example

Creates the infrastructure and one VM cluster. Client and backup subnets must already exist. Database homes are a later step.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="availability_domain=ABcd:AP-SEOUL-1-AD-1" \
  -var="shape=Exadata.X9M" \
  -var='vm_cluster={"display_name":"vmc","hostname":"exa","cpu_core_count":4,"gi_version":"23.0.0.0","subnet_id":"ocid1.subnet.oc1.ap-seoul-1.example","backup_subnet_id":"ocid1.subnet.oc1.ap-seoul-1.example","ssh_public_keys":["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample"]}'
```
