# Generative AI complete example

Creates a dedicated AI cluster and attaches an existing capacity reservation. That attachment is the provider 9.11 bring-your-own reservation argument.

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..example" \
  -var="unit_shape=YOUR_HOSTING_SHAPE" \
  -var="capacity_reservation_id=ocid1.generativeaicapacityreservation.oc1.iad.example"
```
