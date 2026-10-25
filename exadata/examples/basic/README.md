# Exadata basic example

Creates Cloud Exadata infrastructure and stops before the VM cluster. Confirm the shape in the target region. This service is billed.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="availability_domain=ABcd:AP-SEOUL-1-AD-1" \
  -var="shape=Exadata.X9M"
```
