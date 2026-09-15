# Landing Zone Basic Example

Creates the default folder structure (Core / Infrastructure / Security / Workloads + children) on the management account. No member accounts.

## Usage

```bash
terraform init
terraform plan -var='create_resource_directory=false'
```

Use management/master account credentials. Set `create_resource_directory=true` only when enabling Resource Directory for the first time.
