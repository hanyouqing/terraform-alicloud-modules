# Bastionhost Complete Example

Full configuration surface: instance (optional), users, groups, hosts, host accounts, and attachments.

## Usage

```bash
terraform apply \
  -var='create_instance=false' \
  -var='instance_id=bastionhost-cn-xxxxx' \
  -var='users={ops={password="ChangeMe!123",display_name="Ops"}}' \
  -var='user_groups={admins={}}' \
  -var='hosts={app1={host_private_address="10.0.1.10",os_type="Linux",source="Local"}}' \
  -var='host_accounts={root_app1={host_key="app1",host_account_name="root",password="HostPass!123"}}' \
  -var='user_attachments={ops_admins={user_key="ops",user_group_key="admins"}}' \
  -var='host_account_user_group_attachments={root_admins={host_account_key="root_app1",user_group_key="admins",host_key="app1"}}'
```
