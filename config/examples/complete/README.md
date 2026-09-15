# Cloud Config Complete Example

Recorder, multiple managed rules, compliance pack, and optional Resource Directory aggregator for Landing Zone.

## Usage

```bash
terraform init
terraform plan
# Multi-account (management / Config delegated admin):
terraform plan -var='create_aggregator=true'
```
