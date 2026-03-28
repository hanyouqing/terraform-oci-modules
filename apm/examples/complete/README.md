# APM Complete Example

This example demonstrates a production-ready APM setup with an APM domain and multiple Synthetics monitors.

## Features

- APM domain (free tier or paid)
- REST health check monitor (10 runs/hour)
- Browser page load monitor (5 runs/hour)
- DNS resolution monitor (5 runs/hour)
- Configurable vantage points
- Total: 20 runs/hour (within free tier if split across hours)

## Usage

```bash
terraform init
terraform plan \
  -var="compartment_id=ocid1.compartment.oc1..xxxxx" \
  -var="health_check_url=https://myapp.example.com/health" \
  -var="browser_check_url=https://myapp.example.com" \
  -var="dns_check_target=myapp.example.com"
terraform apply
```

## Monitor Types

| Monitor | Type | Interval | Runs/Hour |
|---------|------|----------|-----------|
| health-check | REST | 360s (6min) | 10 |
| browser-check | BROWSER | 720s (12min) | 5 |
| dns-check | DNS | 720s (12min) | 5 |

## Production Considerations

- Free tier allows 10 synthetic runs/hour — budget accordingly
- Use REST monitors for lightweight checks; Browser for full page loads
- Choose vantage points close to your users for realistic latency
- Set up Monitoring alarms on monitor failure notifications
- Use scripted monitors (SCRIPTED_REST, SCRIPTED_BROWSER) for complex flows
