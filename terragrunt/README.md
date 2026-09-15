# Terragrunt Configuration for Alibaba Cloud Modules

[Terragrunt](https://terragrunt.gruntwork.io/) wrapper for the Alibaba Cloud Terraform modules in this repo. Supports **multi-account**, **multi-region**, and **multi-environment** deployments with isolated OSS remote state, generated `alicloud` provider config, and cross-module dependencies.

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) | `>= 0.55` (demo pins `0.80.4`) |
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | `>= 1.14.2` |
| Alibaba Cloud credentials | RAM user / STS (see auth below) |

## Module examples vs Terragrunt stacks

The same **basic / complete** idea appears at two levels:

| Layer | `basic` | `complete` |
|-------|---------|------------|
| **Module** (`<module>/examples/`) | Learn one module quickly — few inputs, cheap defaults | Production-shaped defaults (HA, encryption, SSL, deletion protection where the module allows) |
| **Terragrunt** (`terragrunt/demo/.../`) | Minimal greenfield stack (VPC + SG + ECS + OSS) | Enterprise stack (networking, data, LB, observability, governance, stubs for upcoming modules) |

Use module examples when exploring a single service; use Terragrunt stacks when wiring dependencies and remote state across modules.

## Directory Structure

Layout: **Account → Region → Environment (stack) → Module unit**.

```
terragrunt/
├── root.hcl                       # Remote state (OSS), provider gen, shared inputs
├── _envcommon/                    # Per-module shared defaults + terraform.source
│   ├── vpc.hcl
│   ├── security-group.hcl
│   ├── ecs.hcl
│   ├── oss.hcl
│   ├── rds.hcl
│   ├── redis.hcl
│   ├── alb.hcl
│   ├── kms.hcl
│   ├── sls.hcl
│   ├── cms.hcl
│   ├── cr.hcl
│   ├── dns.hcl
│   ├── actiontrail.hcl
│   ├── config.hcl
│   ├── kafka.hcl
│   ├── elasticsearch.hcl
│   ├── arms.hcl
│   ├── cicd.hcl
│   └── …                          # disk, vpn, ack, … (add leaf units as needed)
│
└── demo/                          # ← Account
    ├── .terragrunt-version
    ├── account.hcl
    └── cn-hangzhou/               # ← Region
        ├── region.hcl
        ├── basic/                 # ← minimal greenfield stack
        │   ├── env.hcl            # environment = "basic", project = "alicloud-modules"
        │   ├── vpc/
        │   ├── security-group/
        │   ├── ecs/
        │   └── oss/
        └── complete/              # ← enterprise production-oriented stack
            ├── env.hcl            # environment = "complete"
            ├── vpc/               # multi-AZ public+private, NAT on
            ├── security-group/
            ├── ecs/
            ├── oss/
            ├── kms/
            ├── sls/
            ├── cms/
            ├── rds/               # MySQL HighAvailability + zone_id_slave_a
            ├── redis/
            ├── alb/
            ├── kafka/
            ├── elasticsearch/
            ├── arms/
            ├── cicd/              # stub until cicd/ module exists
            ├── cr/
            ├── dns/
            ├── actiontrail/
            └── config/
```

### Stack comparison

| | **basic** | **complete** |
|---|-----------|--------------|
| Goal | Cheap greenfield smoke-test | Production-shaped reference |
| AZ | Single (`TF_VAR_zone_id_a`) | Dual (`TF_VAR_zone_id_a` / `_b`) |
| NAT | Off | On + private route tables |
| Units | vpc, security-group, ecs, oss | Above + data, LB, logs, KMS, CMS, CR, DNS, ActionTrail, Config, and stubs |
| ECS | Public vSwitch, 1 Mbps egress (no NAT) | Private vSwitch, encrypted disk |
| RDS / Redis / ALB | — | Wired to VPC; SSL / deletion_protection where applicable |

### Adding a new account, region, or stack

| Want to add | What to create |
|-------------|----------------|
| **Account** | New directory under `terragrunt/`, copy `account.hcl` |
| **Region** | New directory under `<account>/`, create `region.hcl` |
| **Stack / env** | New directory under `<account>/<region>/`, create `env.hcl`, copy or adapt module unit dirs |

## Configuration Layers

Each leaf `terragrunt.hcl` resolves four config layers (deepest wins):

```
Root root.hcl                                 → provider_tg.tf + backend.tf + shared inputs
  └─ <account>/account.hcl                    → account_name, account_id
      └─ <account>/<region>/region.hcl        → region
          └─ _envcommon/<module>.hcl           → terraform.source + module defaults
              └─ <account>/<region>/<env>/<module>/terragrunt.hcl → overrides + dependencies
```

**Root `root.hcl`** provides:
- Remote state ([Terraform `backend "oss"`](https://developer.hashicorp.com/terraform/language/backend/oss))
- Provider generation (`provider_tg.tf`) with `region` from `region.hcl`
- Shared inputs: `project`, `environment`, `tags` (`Project` / `Environment` / `Account` / `Region` / `ManagedBy`)

`_envcommon/*.hcl` uses **local** `terraform.source` paths (`../<module>`). For published stacks, pin a git ref, for example:

`source = "git::https://github.com/hanyouqing/terraform-alicloud-modules.git//vpc?ref=vX.Y.Z"`

Stub `_envcommon` files (`kafka`, `elasticsearch`, `arms`, `cicd`) already point at sibling module paths so leaf units work once those modules land.

## Authentication

Do **not** hardcode secrets in HCL. Use environment variables (see repo root [`env.sh.example`](../env.sh.example)):

```bash
cp env.sh.example .env.sh   # gitignored
# edit .env.sh — set ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY / ALICLOUD_REGION
source .env.sh
```

| Variable | Purpose |
|----------|---------|
| `ALICLOUD_ACCESS_KEY` | Access key ID (RAM user preferred) |
| `ALICLOUD_SECRET_KEY` | Access key secret |
| `ALICLOUD_REGION` | Region (should match `region.hcl`, e.g. `cn-hangzhou`) |
| `ALICLOUD_SECURITY_TOKEN` | Optional STS token |
| `ALICLOUD_ASSUME_ROLE_ARN` | Optional assume-role ARN |
| `TF_VAR_account_name` | Optional override for `account.hcl` |
| `TF_VAR_account_id` / `ALICLOUD_ACCOUNT_ID` | Optional account ID placeholder |

The Terraform OSS backend and `alicloud` provider both read these env vars.

## Remote State (OSS)

**Create the state bucket once** before any `terragrunt init` / `plan`. Name must match `local.state_bucket` in `root.hcl`: `<project>-tfstate` (demo: `alicloud-modules-tfstate`).

```bash
aliyun oss mb oss://alicloud-modules-tfstate --region cn-hangzhou
# Enable versioning in the Console or via CLI for safer recovery
```

State object key layout:

`<region>/<environment>/<path_relative_to_include()>/terraform.tfstate`

Examples:
- `cn-hangzhou/basic/demo/cn-hangzhou/basic/vpc/terraform.tfstate`
- `cn-hangzhou/complete/demo/cn-hangzhou/complete/rds/terraform.tfstate`

Optional locking: add Table Store (`tablestore_endpoint` / `tablestore_table`) to `remote_state.config` in `root.hcl`.

## Zone IDs

VPC / ALB / RDS defaults use **placeholder** zones (`cn-hangzhou-h`, `cn-hangzhou-i`). **Set real zones** for your account before apply:

```bash
aliyun ecs DescribeZones --RegionId cn-hangzhou
export TF_VAR_zone_id_a=cn-hangzhou-i
export TF_VAR_zone_id_b=cn-hangzhou-j
```

`basic` only needs `TF_VAR_zone_id_a`. `complete` needs both.

## Suggested Apply Order

### basic

```bash
cd terragrunt/demo/cn-hangzhou/basic

cd vpc && terragrunt apply && cd ..
cd security-group && terragrunt apply && cd ..
cd oss && terragrunt apply && cd ..
cd ecs && terragrunt apply && cd ..
```

Or:

```bash
cd terragrunt/demo/cn-hangzhou/basic
terragrunt run-all plan
terragrunt run-all apply
```

### complete

```bash
cd terragrunt/demo/cn-hangzhou/complete

# 1. Networking
cd vpc && terragrunt apply && cd ..

# 2. Security + independent services (order flexible)
cd security-group && terragrunt apply && cd ..
cd kms && terragrunt apply && cd ..
cd sls && terragrunt apply && cd ..
cd cms && terragrunt apply && cd ..
cd oss && terragrunt apply && cd ..
cd cr && terragrunt apply && cd ..
cd dns && terragrunt apply && cd ..
cd actiontrail && terragrunt apply && cd ..
cd config && terragrunt apply && cd ..
cd arms && terragrunt apply && cd ..
# cd cicd && terragrunt apply && cd ..   # skip until cicd/ module exists

# 3. Workloads that depend on VPC
cd ecs && terragrunt apply && cd ..
cd rds && terragrunt apply && cd ..
cd redis && terragrunt apply && cd ..
cd alb && terragrunt apply && cd ..
cd kafka && terragrunt apply && cd ..
cd elasticsearch && terragrunt apply && cd ..

# 4. Data / AI (opt-in; EMR leaf defaults create_cluster=false)
cd pai && terragrunt apply && cd ..
cd maxcompute && terragrunt apply && cd ..
cd dataworks && terragrunt apply && cd ..
cd fcv3 && terragrunt apply && cd ..
cd adb && terragrunt apply && cd ..
cd hologram && terragrunt apply && cd ..
cd realtime-compute && terragrunt apply && cd ..
# cd emr && terragrunt apply && cd ..   # heavy / costly — enable create_cluster explicitly
```

Dependencies with `mock_outputs` allow `terragrunt plan` / `validate` before VPC exists. Apply still requires real dependency outputs.

```bash
cd terragrunt/demo/cn-hangzhou/complete
terragrunt run-all plan
terragrunt run-all apply
```

Terragrunt respects `dependency` blocks (vpc → security-group / ecs / rds / redis / alb / kafka / elasticsearch / adb / hologram / realtime-compute / emr).

Skip `cicd` until that module exists under the repo root. EMR complete leaf is present but off by default.

## Quick Start Checklist

1. Source credentials from `.env.sh` (from `env.sh.example`)
2. Create OSS bucket `alicloud-modules-tfstate` once
3. Confirm `account.hcl` / `region.hcl` / `env.hcl` for **basic** or **complete**
4. Set real `TF_VAR_zone_id_*` (and ECS image / key / Redis password as needed)
5. Apply in the order above for that stack

## Modules Without Leaf Units Yet

| `_envcommon` | Notes |
|--------------|--------|
| `disk.hcl` | Copy a leaf from `ecs` pattern; attach via `attachments` |
| `vpn.hcl` | Add leaf with `dependency "vpc"` for `vpc_id` / `vswitch_id` |
| `ack`, `cdn`, `nlb`, … | Defaults exist; add leaves under a stack when needed |
| `cicd.hcl` | Leaf + `_envcommon` stub under **complete**; apply after `cicd/` module lands |
| `pai` / `maxcompute` / `realtime-compute` / `hologram` / `adb` / `fcv3` / `dataworks` | Complete leaves added; VPC deps where needed |
| `emr.hcl` | Complete leaf present with `create_cluster=false` (cost) |
