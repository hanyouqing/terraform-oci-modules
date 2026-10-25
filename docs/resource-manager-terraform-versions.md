# OCI Resource Manager 与 Terraform 版本

核对日期：2026-10-25。`tf-v1.5` 是给 OCI Resource Manager 长期维护的分支。Resource Manager 当前能跑的 Terraform 停在 **1.5.x（CLI 1.5.7）**。本分支的模块约束是 **`>= 1.5.0, < 1.6.0`**，CI 与 `.terraform-version` 使用 **1.5.7**。每个模块的 `examples/resource-manager` 是可直接打包上传的栈。`main` 分支继续跟踪当前 Terraform，不要把本分支整支合并回 `main`。

## Resource Manager 列出的版本

来源：[Supported Terraform Versions](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Reference/terraformversions.htm)。表中的 `.x` 表示该次版本的各个小版本。Oracle 写明不按补丁号单独支持，Resource Manager 使用预置的 CLI 版本，1.5 这条线的 CLI 是 **1.5.7**。不能在栈上自行安装另一个补丁号。

| Terraform 版本（CLI） | 支持开始 | 2026-10-24 的状态 |
| --- | --- | --- |
| 1.5.x（1.5.7） | 2024-07-30 | 页面上仍可用来创建栈和作业的版本 |
| 1.2.x（1.2.9） | 2023-02-24 | 2026-04-30 起不能再用它新建栈或作业，也不再接受该版本栈的支持请求 |
| 1.1.x（1.1.3） | 2022-05-07 | 同上 |
| 1.0.x（1.0.0） | 2021-06-24 | 同上 |

同一页还列出更早已经结束支持的 0.14.x、0.13.x、0.12.x（作业支持停于 2025-09-01）和 0.11.x（2021-09-01）。那些版本不能作为新栈的选择。

2026-04-30 之后，低于 1.5.x 的栈不能再创建作业。仍停在 1.0、1.1 或 1.2 的栈，要升到 Resource Manager 实际提供的 **1.5.x**。Resource Manager 没有 1.6 及以后的运行时。把栈选成“1.5 或更高”不会在该服务里跑到 1.14。

## 本仓库和 HashiCorp 最新版

| 位置 | 版本 | 来源 |
| --- | --- | --- |
| 模块 `required_version`（本分支） | >= 1.5.0, < 1.6.0 | 各模块与方案的 `versions.tf` |
| CI、`.terraform-version`（本分支） | 1.5.7 | 仓库根 [README](../README.md) 的 Prerequisites |
| `main` 分支 | >= 1.14.2，CI 1.16.6 | 不在本分支上 |
| HashiCorp 发布目录里的最新稳定版 | 1.17.0 | [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/)，2026-10-24 查看 |

1.6 及以后的语言不能出现在本分支。下面按“1.5 已有的能力”和“1.6 到 1.14 新增、Resource Manager 跑不到的能力”分开写。`main` 的下限仍是 1.14.2。1.15 到 1.17 的条目只作差异索引。

各版完整列表以 HashiCorp 的升级说明为准：[Upgrade guides](https://developer.hashicorp.com/terraform/language/upgrade-guides)。用页面上的版本选择器打开对应小版本。发布说明在 [GitHub releases](https://github.com/hashicorp/terraform/releases)。

## 1.5 里已经有、Resource Manager 能解析的语言

这些在 Terraform 1.5 引入，CLI 1.5.7 可以解析。来源：[v1.5.0 release](https://github.com/hashicorp/terraform/releases/tag/v1.5.0)。

- `import` 块，以及 `terraform plan -generate-config-out` 生成 HCL。1.5 的 `id` 是字面量。变量和 `for_each` 是后面版本才加的。
- `check` 块，用来写不绑在单个资源生命周期上的断言。本仓库的 PostgreSQL 与 GoldenGate 模块使用了 `check`。
- `plantimestamp()`、`strcontains()` 等 1.5 起提供的函数。

本分支的 `required_version` 是 `>= 1.5.0, < 1.6.0`，Resource Manager 选择 1.5.7 时可以初始化。跨变量约束放在 `check` 块里，因为 1.5.7 的 `validation` 不能引用其它变量。`&&` 和 `||` 两边都会计算，空值守卫要写成 `var.x == null ? true : (其余表达式)`。`examples/resource-manager` 不写 `backend` 块，状态由 Resource Manager 保存。

## 1.6 到 1.14：Resource Manager 跑不到的能力

### 导入、删除与测试（1.6–1.7）

来源：[v1.6.0](https://github.com/hashicorp/terraform/releases/tag/v1.6.0)、[v1.7.0](https://github.com/hashicorp/terraform/releases/tag/v1.7.0)。

- 1.6：`import` 块的 `id` 可以是变量或其它表达式。`terraform test` 与 `.tftest.hcl` 一般可用。
- 1.7：`import` 块支持 `for_each`。测试里可以 mock provider 和模块。`removed` 块用代码把资源移出 state，并保留云上的对象。

### Provider 函数与变量校验（1.8–1.9）

来源：[v1.8.0](https://github.com/hashicorp/terraform/releases/tag/v1.8.0)、[v1.9.0](https://github.com/hashicorp/terraform/releases/tag/v1.9.0)。

- 1.8：provider 可以提供自己的函数，调用形式是 `provider::<name>::<function>()`。`moved` 块可以在不同资源类型之间迁移 state。
- 1.9：变量的 `validation` 可以引用其它输入变量。`templatestring()` 把字符串当模板渲染。

### 不进 state 的值，以及 S3 锁（1.10–1.11）

来源：[Terraform 1.10 ephemeral values](https://www.hashicorp.com/en/blog/terraform-1-10-improves-handling-secrets-in-state-with-ephemeral-values)、[v1.11.0](https://github.com/hashicorp/terraform/releases/tag/v1.11.0)、[S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)。

- 1.10：`ephemeral` 资源、临时的输入和输出。这些值留在内存里，不写入 state，也不写入 plan 文件。
- 1.11：write-only 属性，只写不读回 state。测试 mock 可以设置 `override_during = plan`。`terraform test` 的细节以该版 changelog 为准。
- 1.11：AWS `backend "s3"` 的锁改为同一只 bucket 里的锁对象，配置是 `use_lockfile = true`，对象名是 `<key>.tflock`。`dynamodb_table` 从这一版起标记为弃用。这不是 S3 Object Lock（对象保留期限）那项功能。本仓库的状态后端是 `backend "oci"`，不使用 S3 锁。

### 身份导入与 OCI 后端（1.12–1.14）

来源：[v1.12.0](https://github.com/hashicorp/terraform/releases/tag/v1.12.0)、[backend "oci"](https://developer.hashicorp.com/terraform/language/backend/oci)、[v1.14.0](https://github.com/hashicorp/terraform/releases/tag/v1.14.0)、[Using Object Storage for State Files](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm)。

- 1.12：`import` 可以使用 provider 定义的 identity 属性，不再只有一条字符串 `id`。`terraform test -parallelism` 可以并行跑测试里的 plan 和 apply。
- 1.12：`backend "oci"` 一般可用。锁在 Object Storage 里完成，使用同一套 OCI API 凭据，不另建锁表。Oracle 的说明见上面的 Object Storage 状态文档，以及 [OCI backend 公告](https://blogs.oracle.com/cloud-infrastructure/terraform-oci-state-locking-backend)。
- 1.13：没有改变“本仓库必须用 CLI”这个结论。变更列表见 [v1.13.0](https://github.com/hashicorp/terraform/releases/tag/v1.13.0)。
- 1.14：`terraform query` 与 `*.tfquery.hcl` 的 list resource，用来查询已有基础设施。provider 定义的 `action` 块，用来表达创建、读取、更新、删除之外的操作。`main` 的模块下限是 1.14.2，因此那条线的 CLI 包含 1.14.0 的这些能力。本分支的 1.5.7 不能使用它们。

## 1.15 到 1.17

这些版本高于本仓库 CI 正在使用的 1.16.6 的部分，只列发布说明里已经写明的标题。Resource Manager 同样不能运行它们。

| 版本 | 发布说明中的新增能力 | 来源 |
| --- | --- | --- |
| 1.15 | `terraform validate` 检查 `backend` 块。新增 `convert()` | [v1.15.0](https://github.com/hashicorp/terraform/releases/tag/v1.15.0) |
| 1.16 | provider 的 planned private data。`terraform_data` 的 `store` 块可跨 plan 与 apply 保存 ephemeral 值。`import` 块可以写在模块内。action 增加 `on_failure` | [v1.16.0](https://github.com/hashicorp/terraform/releases/tag/v1.16.0)（2026-08-26） |
| 1.17 | 以发布目录中的 1.17.0 为准 | [1.17.0](https://releases.hashicorp.com/terraform/1.17.0/) |

## 对本仓库的直接后果

| 能力 | 本分支 CLI 1.5.7 | Resource Manager 1.5.7 |
| --- | --- | --- |
| 加载 `required_version` | 可以。1.6 及以上会被 `< 1.6.0` 拒绝 | 选择 Terraform 1.5.x 后可以初始化 |
| `backend "oci"` | 1.5.7 没有这个后端。远程状态留在 `main` | 不写 `backend`，状态由 Resource Manager 保存 |
| `terraform validate -backend=false` | CI 使用 1.5.7 | 同一套配置可以上传为栈 |
| 写入 state | 本分支的模块栈交给 Resource Manager | `examples/resource-manager` 是上传入口 |

写入开关和两边同时 apply 的锁行为见 [FAQs](oci-solutions-architect/FAQs.md) 与 [方案 00](oci-solutions-architect/examples/00-iac-lifecycle/README.md)。
