# Direct Mail Complete Example

Multiple domains and sender addresses (batch + trigger), campaign tags, and receivers list metadata. Override `domains` / `mail_addresses` with domains you control.

## Usage

```bash
terraform init
terraform plan \
  -var='domains={"mail.example.com":{}}' \
  -var='mail_addresses={"noreply":{"account_name":"noreply@mail.example.com","sendtype":"batch"}}'
```

Complete SPF/DKIM/MX verification after apply (see module README and `zzz_reminders`).
