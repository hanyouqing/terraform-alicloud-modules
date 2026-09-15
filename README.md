# Terraform Alibaba Cloud Modules

Production-oriented Terraform modules for [Alibaba Cloud](https://www.alibabacloud.com/), modeled after [terraform-oci-modules](https://github.com/hanyouqing/terraform-oci-modules) and aligned with Terraform, Terragrunt, and Alibaba Cloud best practices.

## Goals

- **Modular**: reusable modules with typed, validated variables
- **Production defaults**: encryption, private ACLs, locked-down ingress, consistent tagging
- **Multi-environment**: Terragrunt account → region → env hierarchy with OSS remote state
- **Latest stable provider**: `aliyun/alicloud` `~> 1.292` (Terraform `>= 1.14.2`)
- **Discoverable examples**: each module ships `examples/basic` and `examples/complete`

> Provider note: Registry may also list `2.0.0-beta*`. These modules pin the latest **stable** 1.x line (`~> 1.292`) for enterprise production. Revisit when 2.0 GA lands.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) `>= 1.14.2`
- [Terragrunt](https://terragrunt.gruntwork.io/) (optional, for stacks under `terragrunt/`)
- [Alibaba Cloud Terraform Provider](https://registry.terraform.io/providers/aliyun/alicloud/latest) `~> 1.292`
- Credentials via environment variables (see `env.sh.example`):

```bash
cp env.sh.example .env.sh   # gitignored
# edit ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY / ALICLOUD_REGION
source .env.sh
```

Prefer a RAM user or STS role over the root account. Least-privilege policies per stack are recommended.

## Modules

| Module | Service | Description |
|--------|---------|-------------|
| [vpc](./vpc) | VPC | VPC, public/private vSwitches, enhanced NAT + EIP + SNAT, route tables, optional flow logs |
| [security-group](./security-group) | ECS SG | Security groups and ingress/egress rules (no open ingress by default) |
| [ecs](./ecs) | ECS | Instances with encrypted ESSD system disks; no public IP by default |
| [disk](./disk) | Cloud Disk | ESSD disks, optional attachments and snapshot policies |
| [oss](./oss) | OSS | Buckets with private ACL, versioning, SSE, TLS-only policy |
| [rds](./rds) | RDS | MySQL/PostgreSQL instances, private network, backups, optional accounts |
| [redis](./redis) | Tair/Redis | KVStore instances with SSL and VPC auth |
| [elasticsearch](./elasticsearch) | Elasticsearch | 搜索 instances; private network, disk encryption, Kibana private preferred |
| [kafka](./kafka) | Message Queue for Apache Kafka | alikafka VPC instance, topics, consumer groups, optional SASL |
| [pai](./pai) | PAI | AI/ML workspace, datasets, models, online services (DashScope API keys out-of-band) |
| [maxcompute](./maxcompute) | MaxCompute | 大数据仓库 projects with IP whitelist / security / properties |
| [realtime-compute](./realtime-compute) | Realtime Compute | Flink VVP instance (VPC) + optional deployments |
| [hologram](./hologram) | Hologres | 实时数仓 instances; prefer SSL + VPC endpoints |
| [arms](./arms) | ARMS | Prometheus + optional Grafana workspace / environments / alert contacts |
| [cicd](./cicd) | CI/CD foundation | CR Personal repos, optional image pipelines + CI assume-role (pipelines out-of-band) |
| [alb](./alb) | ALB | Application Load Balancer, server groups, HTTP/HTTPS listeners |
| [nlb](./nlb) | NLB | Network Load Balancer, server groups, TCP/UDP/TCPSSL listeners |
| [cms](./cms) | CMS | CloudMonitor contacts, contact groups, metric alarms, site monitors |
| [dns](./dns) | DNS | Alidns public domains/records + optional PrivateZone |
| [cdn](./cdn) | CDN | Accelerated domains (`cdn_domain_new`) and optional configs |
| [waf](./waf) | WAFv3 | Domain onboarding; prefer existing `instance_id` (paid instance) |
| [kms](./kms) | KMS | CMKs, aliases, optional secrets |
| [ram](./ram) | RAM / IAM | Users, groups, roles, policies, SAML/OIDC IdP, password/MFA policy |
| [sls](./sls) | SLS | Log projects, stores, optional indexes |
| [vpn](./vpn) | VPN | Site-to-site VPN gateway, customer gateways, IPsec connections |
| [ack](./ack) | ACK | Managed Kubernetes cluster + encrypted node pools |
| [bastionhost](./bastionhost) | Bastionhost | 堡垒机 instance, users, hosts, accounts, attachments |
| [swas](./swas) | SWAS | 轻量应用服务器 instances + firewall rules |
| [cen](./cen) | CEN | 云企业网 instance, attachments, bandwidth, optional TR |
| [express-connect](./express-connect) | Express Connect | 高速通道 / 专线 VBR（物理端口常需线下开通） |
| [direct-mail](./direct-mail) | DirectMail | 邮件推送域名与发信地址 |
| [cr](./cr) | Container Registry | 容器镜像仓库（Personal / EE） |
| [landing-zone](./landing-zone) | Landing Zone | Opinionated multi-account RD blueprint (management account) |
| [resource-directory](./resource-directory) | Resource Directory | Folders, member accounts, control policies, delegated admins |
| [resource-group](./resource-group) | Resource Group | Account-scoped resource groups |
| [cloudsso](./cloudsso) | CloudSSO | Multi-account SSO + external SAML IdP / SCIM, permission sets, assignments |
| [config](./config) | Cloud Config | Configuration recorder, rules, compliance packs, optional RD aggregator |
| [actiontrail](./actiontrail) | ActionTrail | Operation audit trails (prefer OSS delivery for LZ) |
| [adb](./adb) | AnalyticDB | 分析型数据库 lake version 集群 + accounts |
| [emr](./emr) | E-MapReduce v2 | Spark/Hive 大数据集群（成本敏感） |
| [fcv3](./fcv3) | Function Compute 3.0 | Serverless / AI glue / event triggers |
| [dataworks](./dataworks) | DataWorks | 数据开发/治理项目 + resource groups |

Coverage map for a full business stack: [docs/COVERAGE.md](./docs/COVERAGE.md).

## Quick start (module example)

```bash
cd vpc/examples/basic
terraform init
terraform plan
```

Or consume from git:

```hcl
module "vpc" {
  source = "git::https://github.com/hanyouqing/terraform-alicloud-modules.git//vpc?ref=main"

  vpc_name    = "demo-vpc"
  cidr_block  = "10.0.0.0/16"
  project     = "demo"
  environment = "development"

  public_vswitches = {
    public-a = {
      zone_id    = "cn-hangzhou-h"
      cidr_block = "10.0.1.0/24"
    }
  }
}
```

## Terragrunt

See [terragrunt/README.md](./terragrunt/README.md).

Suggested apply order for a greenfield stack:

1. `landing-zone` (management account) → `cloudsso` → `resource-directory` (day-2) / `resource-group`
2. `vpc` → `security-group` → `ecs` / `swas` / `rds` / `redis` / `alb` / `nlb` / `ack`
3. `oss` / `kms` / `sls` / `ram` / `cms` / `dns` / `cr` / `actiontrail` / `config`
4. Data / AI: `pai` / `maxcompute` / `adb` / `hologram` / `realtime-compute` / `dataworks` / `fcv3` (EMR opt-in — costly)
5. `cdn` / `waf` / `vpn` / `express-connect` → `cen` / `disk` / `bastionhost` / `direct-mail` as needed

Create the OSS state bucket once (default name formula: `${project}-tfstate`).

## Development

```bash
make fmt              # terraform fmt + terragrunt hclfmt
make validate         # init -backend=false && validate (modules + examples)
make lint             # tflint
make docs             # terraform-docs inject into module READMEs
make list-modules
make ci               # fmt-check + validate + lint
```

Optional: `pre-commit install` using [.pre-commit-config.yaml](./.pre-commit-config.yaml).

## Tagging convention

All modules merge:

| Key | Value |
|-----|-------|
| `ManagedBy` | `terraform` |
| `Module` | `github.com/hanyouqing/terraform-alicloud-modules/<module>` |
| `Project` | `var.project` |
| `Environment` | `var.environment` |

Plus caller `tags` / freeform maps.

## Security baseline

- Security group ingress empty by default; callers must open ports explicitly
- ECS `internet_max_bandwidth_out = 0` by default (no public IP)
- OSS ACL private; versioning and SSE enabled in production-oriented defaults
- RDS/Redis placed on private vSwitches; passwords marked `sensitive`
- Prefer KMS CMKs for TDE / disk / OSS encryption in production
- Do not commit `*.tfvars`, `.env.sh`, or access keys

## License

Apache License 2.0 — see [LICENSE](./LICENSE).
