# Compute Complete Example

This example demonstrates a production-ready compute setup with all features.

## Features

- Flexible instance shapes (E2.1.Micro or A1.Flex)
- Multiple instances with distribution across availability domains
- Custom boot volumes with performance tuning
- Block volumes with auto-tune support
- Network Security Group integration
- User data scripts for initialization
- Monitoring and management agent support
- Encryption in transit
- Comprehensive tagging

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Production Considerations

- High availability with multi-AZ deployment
- Performance optimization with custom boot volumes
- Security hardening with NSGs and encryption
- Monitoring and management capabilities
- Automated initialization with user data
- Cost optimization with proper tagging
