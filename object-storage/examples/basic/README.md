# Object Storage Basic Example

This example creates a minimal Always Free object storage bucket.

## Features

- Single bucket with standard storage tier
- No public access (secure by default)
- Suitable for Always Free tier (20 GB limit)

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="region=ap-seoul-1"
terraform apply
```

Change the bucket `name` in `main.tf` if it already exists in your namespace (names must be unique per Object Storage namespace).

## Always Free Considerations

- Standard storage tier (within 20 GB free limit)
- No public access (security best practice)
- No versioning (saves costs)
- Suitable for basic storage needs
