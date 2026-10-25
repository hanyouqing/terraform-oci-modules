# Generative AI basic example

Creates one hosting dedicated AI cluster on on-demand capacity. Supply a unit shape that the region offers. Dedicated clusters are billed and are not Always Free.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="unit_shape=YOUR_HOSTING_SHAPE"
```
