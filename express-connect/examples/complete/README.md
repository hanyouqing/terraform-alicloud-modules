# Express Connect Complete Example

Multiple VBRs on an existing (or optionally created) physical connection, with optional router interfaces for legacy VBR↔VPC attachment. Prefer CEN for multi-region designs.

## Usage

```bash
terraform init
terraform plan \
  -var='physical_connection_id=pc-xxxxxxxx'
```

To also create a physical connection (access point + operator required):

```bash
terraform plan \
  -var='create_physical_connection=true' \
  -var='access_point_id=ap-cn-hangzhou-yh-B' \
  -var='line_operator=CT' \
  -var='peer_location=Hangzhou'
```
