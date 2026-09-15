# Shared module defaults

Each `*.hcl` file here is included by `<account>/<region>/<env>/<module>/terragrunt.hcl` with `merge_strategy = "deep"`.

## Config layers

Each file reads two config layers via `find_in_parent_folders()`:

| File | Provides |
|------|----------|
| `region.hcl` | `region` |
| `env.hcl` | `environment`, `project` |

Account-level values and shared `tags` are injected by the root `root.hcl` shared inputs — they are NOT repeated here.

## `terraform.source`

Each file points at the **local workspace** module path
(`${dirname(find_in_parent_folders("root.hcl"))}/../<module>`) so edits apply before push.
For published stacks, pin a git ref instead, e.g.
`git::https://github.com/hanyouqing/terraform-alicloud-modules.git//vpc?ref=vX.Y.Z`.

## Zone IDs

VPC vSwitch defaults use placeholder zone IDs (e.g. `cn-hangzhou-h`). **Callers must set
real availability zones** for the target region before apply (Console / `aliyun ecs DescribeZones`).

## Stubs

`cicd.hcl` points at `../cicd` before that module exists. `kafka`, `elasticsearch`, and `arms`
already have modules; their `_envcommon` files carry production-shaped defaults for the
**complete** stack.

Data / AI stubs: `pai`, `maxcompute`, `realtime-compute`, `hologram`, `adb`, `emr`, `fcv3`,
`dataworks`. Wire `dependency "vpc"` for `realtime-compute`, `hologram`, `adb`, and `emr`.
EMR leaf keeps `create_cluster=false` by default (cost).
