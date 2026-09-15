# Direct Mail Module (邮件推送)

Registers Direct Mail domains and sender addresses for transactional and batch email on Alibaba Cloud.

## Features

- `alicloud_direct_mail_domain` via `for_each`
- `alicloud_direct_mail_mail_address` via `for_each` (`account_name`, `sendtype`)
- Optional `alicloud_direct_mail_tag` and `alicloud_direct_mail_receivers`
- Outputs expose IDs and account names only — **no passwords**

## DNS verification (SPF / DKIM)

After creating domains, complete verification in DNS (exact values are shown in the Direct Mail console):

1. **SPF** — TXT record including Alibaba Cloud Direct Mail (typically `include:spf1.dm.aliyun.com`)
2. **DKIM** — CNAME or TXT records from the console verification panel
3. **MX** — bounce handling (often `mx01.dm.aliyun.com`)
4. Wait until domain `status` is Available / Passed before production sends

See `zzz_reminders` output for a checklist.

## Examples

| Example | Description |
|---------|-------------|
| `examples/basic` | One domain + one batch sender |
| `examples/complete` | Multiple domains/addresses, tags, receivers |

## Usage

```hcl
module "direct_mail" {
  source = "../direct-mail"

  domains = {
    "mail.example.com" = {}
  }

  mail_addresses = {
    noreply = {
      account_name = "noreply@mail.example.com"
      sendtype     = "batch"
    }
  }

  project     = "my-project"
  environment = "production"
}
```

## Requirements

- Terraform >= 1.14.2
- Provider `aliyun/alicloud` ~> 1.292
- Direct Mail is region-sensitive; examples default to `cn-hangzhou`

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
