# APM Basic Example

This example creates a single Always Free APM domain.

## Features

- Single APM domain with free tier enabled
- 1,000 tracing events/hour
- 10 synthetic monitor runs/hour available
- Suitable for development and testing

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx"
terraform apply
```

## After Apply

1. Note the `data_upload_endpoint` from outputs (treat as secret)
2. Install APM agent in your application using the endpoint
3. Optionally add Synthetics monitors to probe your endpoints

## Always Free Considerations

- 1 free-tier APM domain per tenancy
- 1,000 tracing events/hour (distributed tracing)
- 10 synthetic monitor runs/hour
- 14-day trace data retention
