# Business coverage checklist

Maps common Alibaba Cloud building blocks for a full business system to modules in this repository.

| Status | Meaning |
|--------|---------|
| **covered** | Module exists with examples |
| **partial** | Core resources in TF; some surfaces remain console/order/API |
| **out-of-band** | Prefer console, carrier, Yunxiao/GitHub — limited Terraform |

## Your checklist

| 业务能力 | Module | Status | Notes |
|----------|--------|--------|-------|
| 日志 | [sls](../sls) | covered | Project / Logstore / index |
| 监控 | [cms](../cms) | covered | CloudMonitor groups / site monitor |
| 告警 | [cms](../cms) | covered | Contacts, contact groups, metric alarms |
| 云主机 ECS | [ecs](../ecs) | covered | |
| 轻量应用服务器 | [swas](../swas) | covered | Simple Application Server |
| VPC | [vpc](../vpc) | covered | |
| 安全组 | [security-group](../security-group) | covered | |
| 堡垒机 | [bastionhost](../bastionhost) | partial | Paid instance; examples can attach to existing ID |
| VPN | [vpn](../vpn) | covered | Site-to-site IPsec |
| 海外专线 / 专线接入 | [express-connect](../express-connect) | partial | Physical ports often ordered offline; TF manages VBR |
| 高速通道 / 跨地域 | [cen](../cen) + [express-connect](../express-connect) | covered | CEN hub + VBR attachments |
| 负载均衡 | [alb](../alb) / [nlb](../nlb) | covered | ALB L7 + NLB L4 (classic SLB legacy, not primary) |
| WAF | [waf](../waf) | partial | WAFv3 domains; prefer existing paid `instance_id` |
| CDN | [cdn](../cdn) | covered | Domestic / overseas / global scope |
| DNS | [dns](../dns) | covered | Alidns + optional PrivateZone |
| K8s / ACK | [ack](../ack) | covered | Managed cluster + node pools |
| 搜索 / Elasticsearch | [elasticsearch](../elasticsearch) | covered | Instance for_each; private + disk encryption defaults |
| 消息队列 Kafka | [kafka](../kafka) | covered | alikafka VPC instance, topics, groups, optional SASL |
| 性能监控 / APM | [arms](../arms) | covered | Prometheus + optional Grafana workspace / environments |
| 代码仓库 | — | out-of-band | Codeup has limited TF; use GitHub/GitLab/Codeup console |
| CI/CD | [cicd](../cicd) | partial | CR repos + optional image pipelines + CI role; Yunxiao/Codeup pipelines out-of-band |
| 邮件服务 | [direct-mail](../direct-mail) | partial | Domains/addresses in TF; SPF/DKIM verify in DNS |
| 容器镜像仓库 | [cr](../cr) / [cicd](../cicd) | covered | Personal or EE; cicd focuses on Personal + CI identity |

## AI / LLM / Big Data / Stream

| 业务能力 | Module | Status | Notes |
|----------|--------|--------|-------|
| PAI 自定义训练 / 推理 | [pai](../pai) | covered | Workspace + optional datasets / models / online services |
| DashScope / 百炼 LLM API | — | out-of-band | API keys and model marketplace are console/order — not Terraform; use PAI for custom infra |
| MaxCompute 大数据仓库 | [maxcompute](../maxcompute) | covered | Project for_each; IP whitelist / security / properties |
| Realtime Compute Flink | [realtime-compute](../realtime-compute) | covered | VVP instance (VPC) + optional deployments |
| Hologres 实时数仓 | [hologram](../hologram) | covered | Instance for_each; prefer SSL + VPC endpoints |
| AnalyticDB 分析库 | [adb](../adb) | covered | Lake version; disk encryption + SSL defaults |
| E-MapReduce | [emr](../emr) | covered | EMRv2 Spark/Hive; costly — Terragrunt leaf off by default |
| Function Compute 3.0 | [fcv3](../fcv3) | covered | Serverless glue / triggers; pair with PAI + CR |
| DataWorks 数据开发 | [dataworks](../dataworks) | covered | Project + optional DW resource groups / members |

## Also covered (common stack)

| Need | Module | Status |
|------|--------|--------|
| OSS | [oss](../oss) | covered |
| Cloud disk | [disk](../disk) | covered |
| RDS | [rds](../rds) | covered |
| Redis / Tair | [redis](../redis) | covered |
| Elasticsearch | [elasticsearch](../elasticsearch) | covered |
| Kafka (alikafka) | [kafka](../kafka) | covered |
| PAI (AI/ML) | [pai](../pai) | covered |
| MaxCompute | [maxcompute](../maxcompute) | covered |
| Realtime Compute Flink | [realtime-compute](../realtime-compute) | covered |
| Hologres | [hologram](../hologram) | covered |
| AnalyticDB | [adb](../adb) | covered |
| EMR v2 | [emr](../emr) | covered |
| FC 3.0 | [fcv3](../fcv3) | covered |
| DataWorks | [dataworks](../dataworks) | covered |
| ARMS / Prometheus | [arms](../arms) | covered |
| CI/CD foundation | [cicd](../cicd) | partial |
| KMS | [kms](../kms) | covered |
| RAM | [ram](../ram) | covered | Users/roles/policies + SAML/OIDC IdP + MFA/password policy |
| Cloud Config | [config](../config) | covered |
| ActionTrail | [actiontrail](../actiontrail) | covered |

## 组织 / 多账号 / Landing Zone

Multi-account Resource Directory blueprint and supporting org modules.

| 业务能力 | Module | Status | Notes |
|----------|--------|--------|-------|
| Landing Zone 蓝图 | [landing-zone](../landing-zone) | covered | Opinionated RD folders / optional members / baseline SCPs — **management account only** |
| Resource Directory | [resource-directory](../resource-directory) | covered | Flexible folders / accounts / control policies / delegated admins |
| CloudSSO | [cloudsso](../cloudsso) | covered | Directory, SAML IdP, SCIM, users/groups, access configurations, assignments |
| Resource Group | [resource-group](../resource-group) | covered | Per-account resource grouping |
| 合规检测 (多账号) | [config](../config) | covered | Single-account rules + optional RD aggregator |
| 操作审计 (多账号) | [actiontrail](../actiontrail) | covered | Prefer OSS delivery; `is_organization_trail` for org trails |

## Identity / IAM / SAML

| 业务能力 | Module | Status | Notes |
|----------|--------|--------|-------|
| RAM（账号内 IAM） | [ram](../ram) | covered | Users/roles/policies/groups + password/MFA policy |
| RAM SAML IdP（单账号联邦） | [ram](../ram) | covered | `saml_providers` + federated roles (`AssumeRoleWithSAML`) |
| RAM OIDC IdP（CI 联邦） | [ram](../ram) | covered | `oidc_providers` (`AssumeRoleWithOIDC`) |
| CloudSSO（多账号 SSO） | [cloudsso](../cloudsso) | covered | RD 组织级目录、权限集、账号分配 |
| CloudSSO 外部 SAML IdP | [cloudsso](../cloudsso) | covered | Directory `saml_identity_provider_configuration` + SP outputs |
| CloudSSO SCIM | [cloudsso](../cloudsso) | covered | `scim_server_credentials` + sync status |
| 应用级 SAML/OIDC（客户应用） | — | out-of-band | 非云账号 IAM；用自建 IdP / OpenAuth 等 |

Suggested LZ order: `landing-zone` (management) → `cloudsso` / `resource-directory` → shared `vpc` in log/security → `actiontrail` + `config` aggregator → member workloads.

## Intentionally deferred

| Need | Why |
|------|-----|
| Classic SLB | Prefer ALB/NLB for new workloads |
| Global Accelerator (GA) | Optional edge acceleration; add when needed |
| NAS / PolarDB | Add when stack requires |
| Codeup / Yunxiao pipelines | Provider coverage thin — use [cicd](../cicd) for CR + CI role; orchestrate pipelines externally |
| DataHub | Prefer [kafka](../kafka) + [realtime-compute](../realtime-compute) for new stream stacks |
| Lindorm / GPDB / ClickHouse / TableStore | Add when OLAP/NoSQL niche is required |

## Suggested greenfield order

1. `landing-zone` (management account) when multi-account is required
2. `vpc` → `security-group` → `ecs` / `swas` / `ack`
3. `rds` / `redis` / `elasticsearch` / `kafka` / `oss` / `disk` / `kms`
4. `pai` / `maxcompute` / `adb` / `hologram` / `realtime-compute` / `dataworks` / `fcv3` (EMR opt-in)
5. `alb` / `nlb` → `waf` → `cdn` → `dns`
6. `sls` → `cms` / `arms` → `actiontrail` / `config`
7. `bastionhost` / `vpn` / `express-connect` → `cen`
8. `ram` / `cr` / `cicd` / `direct-mail`
