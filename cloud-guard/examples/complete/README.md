# Cloud Guard complete example

Enables Cloud Guard and monitors compartments with recipe OCIDs you already have. The module does not clone recipes.

## Usage

```bash
terraform init
terraform plan \
  -var="tenancy_ocid=ocid1.tenancy.oc1..example" \
  -var='targets={"platform":{"compartment_id":"ocid1.compartment.oc1..example","target_resource_id":"ocid1.compartment.oc1..example","detector_recipe_ids":["ocid1.cloudguarddetectorrecipe.oc1..example"]}}'
```
