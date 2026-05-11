---
name: projector
description: |
  Use when the user types "/projector" to initialize or update project knowledge base.
  Creates CLAUDE.md, agent.md, and PROJECTOR/ folder with structured project documentation.
  Solves the problem of AI losing context between conversations by maintaining persistent project knowledge.
version: 1.0.0
argument-hint: "[init|update|scan]"
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
disable-model-invocation: true
---

# Projector - 项目知识库生成器

## 概述

Projector 是一个项目知识管理工具，通过创建结构化的知识库文件，让 AI 在每次对话中都能快速、准确地理解项目上下文。

**解决的问题**:
- 代码分裂：不同组件代码没有复用，各自为政
- 重复编码：相同逻辑在不同组件中重复实现
- 遗忘参考：已解决的 bug 在其他组件中重复出现
- 重回起点：每次新对话都要重新理解项目
- 幻觉反复：注入或依赖未实现的组件

## 触发条件

用户输入 `/projector` 或 `/projector <参数>` 时触发。

## 参数说明

- `init` - 初始化项目知识库（首次使用）
- `update` - 更新现有知识库（增量更新）
- `scan` - 扫描项目结构，输出分析报告（不创建文件）

如果未提供参数，默认执行 `init`。

## 执行流程

### Step 0: 检测项目语言

1. 检查项目根目录是否存在 README.md
2. 分析 README.md 中的中文字符比例
3. 如果中文占比 > 30%，使用中文生成文档；否则使用英文
4. 将检测结果保存到变量 `$LANGUAGE` (zh/en)

### Step 1: 项目分析

1. 扫描项目根目录结构（排除 node_modules, .git, dist 等目录）
2. 识别技术栈：
   - 检查 package.json, pyproject.toml, Cargo.toml, go.mod 等配置文件
   - 识别语言 (TypeScript, Python, Rust, Go 等)
   - 识别框架 (React, Vue, Django, Flask 等)
   - 识别构建工具 (webpack, vite, cargo 等)
3. 分析模块和组件关系：
   - 扫描 src/, lib/, app/ 等源码目录
   - 识别模块边界（目录结构、index 文件）
   - 分析 import/require 依赖关系
4. 检测代码复用机会：
   - 查找相似的工具函数
   - 识别重复的业务逻辑
   - 发现可抽象的通用模式
5. 识别已知问题和解决方案：
   - 扫描注释中的 TODO, FIXME, HACK, XXX
   - 检查 git log 中的 bug 修复记录
   - 识别常见的错误模式

### Step 2: 生成 CLAUDE.md

在项目根目录创建 CLAUDE.md，内容包含：

```markdown
# [项目名称]

[项目一句话描述]

## 项目知识库

**重要**: 本项目使用 projector 管理项目知识。在开始任何工作前，请先阅读：

1. `PROJECTOR/README.md` - 项目总览和使用指南
2. `PROJECTOR/architecture/overview.md` - 系统架构
3. `PROJECTOR/modules/` - 相关模块文档
4. `PROJECTOR/patterns/` - 代码约定和复用清单
5. `PROJECTOR/issues/` - 已知问题和解决方案

## Commands

| Command | Description |
|---------|-------------|
| [从 package.json 等提取] | [自动生成] |

## Architecture

[简要概述，详见 PROJECTOR/architecture/overview.md]

## Code Style

[从代码分析中提取关键约定]

## Gotchas

[从 PROJECTOR/issues/ 提取关键注意事项]
```

### Step 3: 生成 agent.md

在项目根目录创建 agent.md，定义项目专用代理：

```markdown
---
name: project-expert
description: 项目专家代理，负责维护和查询项目知识库
tools: [Read, Write, Edit, Glob, Grep]
model: inherit
---

# Project Expert Agent

你是项目专家代理，负责：

1. 维护 PROJECTOR/ 文件夹中的知识文档
2. 回答关于项目架构和实现的问题
3. 识别代码复用机会
4. 记录已解决的问题和解决方案

## 工作流程

1. 查询问题时，首先检查 PROJECTOR/ 中的相关文档
2. 发现新的模式或解决方案时，更新相应文档
3. 遇到重复代码时，建议复用现有实现
4. 定期扫描项目，更新知识库
```

### Step 4: 创建 PROJECTOR/ 文件夹

创建以下目录结构和文件：

```
PROJECTOR/
├── README.md              # 项目总览和使用指南
├── architecture/          # 架构文档
│   ├── overview.md        # 系统架构概述
│   ├── modules.md         # 模块依赖关系
│   └── data-flow.md       # 数据流图
├── modules/               # 模块详细文档
│   ├── <module-name>.md   # 每个模块的文档
│   └── ...
├── patterns/              # 代码模式和复用
│   ├── reusable.md        # 可复用代码清单
│   ├── conventions.md     # 编码约定
│   └── anti-patterns.md   # 需要避免的模式
├── issues/                # 问题和解决方案
│   ├── resolved.md        # 已解决的问题
│   ├── known-issues.md    # 已知问题
│   └── workarounds.md     # 临时解决方案
└── context/               # 上下文信息
    ├── decisions.md       # 技术决策记录
    ├── dependencies.md    # 依赖关系
    └── environment.md     # 环境配置
```

**文件生成规则**:

1. **README.md** - 根据语言选择生成中文或英文版本
2. **architecture/overview.md** - 从项目分析结果中提取架构信息
3. **architecture/modules.md** - 生成模块依赖关系图（Mermaid 格式）
4. **modules/*.md** - 为每个主要模块生成详细文档
5. **patterns/reusable.md** - 从代码分析中提取可复用代码
6. **patterns/conventions.md** - 从代码风格中提取约定
7. **issues/resolved.md** - 从 git log 中提取已解决的问题
8. **issues/known-issues.md** - 从 TODO/FIXME 中提取已知问题
9. **context/dependencies.md** - 从配置文件中提取依赖关系
10. **context/environment.md** - 从配置文件中提取环境要求

### Step 5: 设置 Git Hook（可选）

如果项目是 git 仓库，询问用户是否安装 Git hook：

1. 显示 hook 的作用说明
2. 如果用户同意，运行 `setup-hooks.sh` 安装 hook
3. hook 会在每次提交后自动检测变更并提示更新

### Step 6: 验证和报告

1. 验证所有文件已创建
2. 输出创建摘要：
   - 创建的文件数量
   - 检测到的技术栈
   - 识别的模块数量
   - 发现的可复用代码数量
3. 提供使用指南：
   - 如何使用知识库
   - 如何更新知识库
   - 如何手动触发更新

## 注意事项

1. **不要覆盖现有文件**: 如果 CLAUDE.md 或 PROJECTOR/ 已存在，询问用户是否覆盖
2. **排除无关目录**: 排除 node_modules, .git, dist, build, __pycache__ 等目录
3. **增量更新**: 使用 `update` 参数时，只更新变更的部分，保留手动编辑的内容
4. **语言一致性**: 所有生成的文档使用相同的语言（中文或英文）
5. **Mermaid 图表**: 使用 Mermaid 语法生成依赖关系图，便于可视化

## 模板位置

所有模板文件位于 `templates/` 目录：
- `templates/README-zh.md` - 中文版项目总览
- `templates/README-en.md` - 英文版项目总览
- `templates/CLAUDE.md` - CLAUDE.md 模板
- `templates/agent.md` - agent.md 模板
- `templates/modules/` - 模块文档模板

## 相关文件

- `scripts/detect-language.py` - 语言检测脚本
- `scripts/analyze-project.sh` - 项目分析脚本
- `scripts/generate-docs.sh` - 文档生成脚本
- `scripts/setup-hooks.sh` - Git hook 安装脚本
- `hooks/post-commit` - 提交后 hook
- `hooks/pre-commit` - 提交前 hook（可选）
- `agents/project-expert.md` - 项目专家代理定义
