# CR Complete Example

Multiple Personal Edition namespaces and private repos by default. Set `create_ee_instance=true` (and a unique `ee_instance_name`) to exercise Enterprise Edition plus optional internet ACL policies.

## Usage

```bash
terraform init
terraform plan
```

Enterprise Edition:

```bash
terraform plan \
  -var='create_ee_instance=true' \
  -var='ee_instance_name=tf-complete-cr-unique' \
  -var='endpoint_acl_policies={"ci":{"entry":"203.0.113.0/24","description":"ci egress"}}'
```

Codeup/Yunxiao pipelines remain out-of-band; push images from CI to the repos created here.
