# OCI Resource Manager 与 Terraform 版本

核对日期：2026-11-13。仓库有两条长期维护的线，不要整支合并。

| 分支 | Terraform | 用途 |
| --- | --- | --- |
| `main`（本分支） | 模块 `>= 1.14.2`，CI 与 `.terraform-version` 为 **1.17.2** | Terraform CLI。远程状态使用 `backend "oci"`（需要 Terraform >= 1.12） |
| [`tf-v1.5`](https://github.com/hanyouqing/terraform-oci-modules/tree/tf-v1.5) | `>= 1.5.0, < 1.6.0`，CI 与 `.terraform-version` 为 **1.5.7** | OCI Resource Manager。每个模块的 `examples/resource-manager` 压缩后即可上传 |

Resource Manager 当前能跑的 Terraform 停在 **1.5.x（CLI 1.5.7）**。没有 1.6 及以后的运行时。`main` 的配置不能作为 Resource Manager 栈上传。修复要按分支分别移植。

## 在 tf-v1.5 上使用 Resource Manager

1. 检出 `tf-v1.5`。
2. 进入目标模块的 `examples/resource-manager`。
3. 压缩该目录。不要带 `.terraform`、`.tfstate`。
4. 在 Resource Manager 创建栈，Terraform 版本选 **1.5.x**，上传压缩包。
5. 在控制台修改参数后 Plan / Apply。`tenancy_ocid`、`compartment_ocid`、`region` 会预填。`provider "oci"` 只设置 `region`。栈里没有 `backend`，状态由 Resource Manager 保存。

改 `tf-v1.5` 上的模块或 `examples/basic` 之后，在该分支运行：

```bash
python3 scripts/tf15_resource_manager.py sync
terraform fmt -recursive
```

用 Terraform **1.5.7** 做 `terraform validate`。

## Resource Manager 列出的版本

来源：[Supported Terraform Versions](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Reference/terraformversions.htm)。表中的 `.x` 表示该次版本的各个小版本。Oracle 写明不按补丁号单独支持，Resource Manager 使用预置的 CLI 版本，1.5 这条线的 CLI 是 **1.5.7**。不能在栈上自行安装另一个补丁号。

| Terraform 版本（CLI） | 支持开始 | 2026-10-24 的状态 |
| --- | --- | --- |
| 1.5.x（1.5.7） | 2024-07-30 | 页面上仍可用来创建栈和作业的版本 |
| 1.2.x（1.2.9） | 2023-02-24 | 2026-04-30 起不能再用它新建栈或作业，也不再接受该版本栈的支持请求 |
| 1.1.x（1.1.3） | 2022-05-07 | 同上 |
| 1.0.x（1.0.0） | 2021-06-24 | 同上 |

同一页还列出更早已经结束支持的 0.14.x、0.13.x、0.12.x（作业支持停于 2025-09-01）和 0.11.x（2021-09-01）。那些版本不能作为新栈的选择。

2026-04-30 之后，低于 1.5.x 的栈不能再创建作业。仍停在 1.0、1.1 或 1.2 的栈，要升到 Resource Manager 实际提供的 **1.5.x**。把栈选成“1.5 或更高”不会在该服务里跑到 1.14。

## 本仓库和 HashiCorp 最新版

| 位置 | 版本 | 来源 |
| --- | --- | --- |
| `main` 的模块 `required_version` | >= 1.14.2 | 各模块 `versions.tf` |
| `main` 的 CI、`.terraform-version` | 1.17.2 | 仓库根 README 的 Prerequisites |
| `tf-v1.5` 的模块 `required_version` | >= 1.5.0, < 1.6.0 | 该分支的 `versions.tf` |
| `tf-v1.5` 的 CI、`.terraform-version` | 1.5.7 | 该分支的 README |
| HashiCorp 发布目录里的最新稳定版 | 1.17.2 | [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/)，2026-11-13 查看 |

1.6 及以后的语言只出现在 `main`。`tf-v1.5` 不能使用它们。下面按“1.5 已有的能力”和“1.6 到 1.14 新增、Resource Manager 跑不到的能力”分开写。1.15 到 1.17 的条目只作差异索引。

各版完整列表以 HashiCorp 的升级说明为准：[Upgrade guides](https://developer.hashicorp.com/terraform/language/upgrade-guides)。发布说明在 [GitHub releases](https://github.com/hashicorp/terraform/releases)。

## 1.5 里已经有、Resource Manager 能解析的语言

这些在 Terraform 1.5 引入，CLI 1.5.7 可以解析。来源：[v1.5.0 release](https://github.com/hashicorp/terraform/releases/tag/v1.5.0)。

- `import` 块，以及 `terraform plan -generate-config-out` 生成 HCL。1.5 的 `id` 是字面量。变量和 `for_each` 是后面版本才加的。
- `check` 块，用来写不绑在单个资源生命周期上的断言。
- `plantimestamp()`、`strcontains()` 等 1.5 起提供的函数。

`tf-v1.5` 的 `required_version` 是 `>= 1.5.0, < 1.6.0`，Resource Manager 选择 1.5.7 时可以初始化。跨变量约束放在 `check` 块里，因为 1.5.7 的 `validation` 不能引用其它变量。`&&` 和 `||` 两边都会计算，空值守卫要写成 `var.x == null ? true : (其余表达式)`。`examples/resource-manager` 不写 `backend` 块。

## 1.6 到 1.14：Resource Manager 跑不到的能力

这些能力可以留在 `main`。不要把它们移植到 `tf-v1.5`。

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
- 1.11：write-only 属性，只写不读回 state。
- 1.11：AWS `backend "s3"` 的锁改为同一只 bucket 里的锁对象。`main` 的状态后端是 `backend "oci"`，不使用 S3 锁。

### 身份导入与 OCI 后端（1.12–1.14）

来源：[v1.12.0](https://github.com/hashicorp/terraform/releases/tag/v1.12.0)、[backend "oci"](https://developer.hashicorp.com/terraform/language/backend/oci)、[v1.14.0](https://github.com/hashicorp/terraform/releases/tag/v1.14.0)、[Using Object Storage for State Files](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/object-storage-state.htm)。

- 1.12：`import` 可以使用 provider 定义的 identity 属性。`terraform test -parallelism` 可以并行跑测试里的 plan 和 apply。
- 1.12：`backend "oci"` 一般可用。锁在 Object Storage 里完成。这条后端留在 `main`。`tf-v1.5` 的 Resource Manager 栈不声明它。
- 1.13：变更列表见 [v1.13.0](https://github.com/hashicorp/terraform/releases/tag/v1.13.0)。
- 1.14：`terraform query` 与 `*.tfquery.hcl` 的 list resource。provider 定义的 `action` 块。`main` 的模块下限是 1.14.2，因此包含这些能力。`tf-v1.5` 的 1.5.7 不能使用它们。

## 1.15 到 1.17

`main` 的 CI 使用 1.17.2。下表只列发布说明里已经写明的标题。Resource Manager 不能运行这些版本。

| 版本 | 发布说明中的新增能力 | 来源 |
| --- | --- | --- |
| 1.15 | `terraform validate` 检查 `backend` 块。新增 `convert()` | [v1.15.0](https://github.com/hashicorp/terraform/releases/tag/v1.15.0) |
| 1.16 | provider 的 planned private data。`terraform_data` 的 `store` 块可跨 plan 与 apply 保存 ephemeral 值。`import` 块可以写在模块内。action 增加 `on_failure` | [v1.16.0](https://github.com/hashicorp/terraform/releases/tag/v1.16.0)（2026-08-26） |
| 1.17 | provider 需求可用变量和 locals。新增 `-minimal-refresh`。Terraform Policy 正式可用 | [v1.17.0](https://github.com/hashicorp/terraform/releases/tag/v1.17.0)（2026-10-21；CI 钉 1.17.2） |

## 对本仓库的直接后果

| 能力 | `main` | `tf-v1.5` / Resource Manager 1.5.7 |
| --- | --- | --- |
| `required_version` | `>= 1.14.2` | `>= 1.5.0, < 1.6.0` |
| CI | 1.17.2 | 1.5.7 |
| `backend "oci"` | 使用 | 不写。状态由 Resource Manager 保存 |
| `examples/resource-manager` | 不在本分支 | 每个模块一份，压缩后上传 |
| 合并 | 不要并入 `tf-v1.5` | 修复按分支移植 |
