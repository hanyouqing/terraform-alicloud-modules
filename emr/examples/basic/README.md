# EMR basic example

PayAsYouGo DATALAKE cluster with structured `node_attributes` and MASTER + CORE `node_groups`.

```bash
terraform init
terraform plan
```

Required: `node_attributes`, `node_groups` (vpc / zone / sg / keypair / ram_role / vswitch).
