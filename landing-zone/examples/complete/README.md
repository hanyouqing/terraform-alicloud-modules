# Landing Zone Complete Example

Default folders, baseline control policies, and placeholder member account display names under Core / Security / Infrastructure / Workloads.

## Usage

```bash
terraform init
terraform plan -var='create_resource_directory=false'
```

Replace placeholder `display_name` values before apply. Creating member accounts is irreversible without org offboarding procedures — plan carefully on the management account.
