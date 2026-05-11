# Projector

<p align="center">
  <strong>让 AI 每次对话都理解你的项目</strong>
</p>

<p align="center">
  <a href="#安装">安装</a> •
  <a href="#快速开始">快速开始</a> •
  <a href="#工作原理">工作原理</a> •
  <a href="#功能特性">功能</a> •
  <a href="#贡献">贡献</a>
</p>

---

## 为什么需要 Projector?

使用 AI 辅助开发时，你是否遇到过这些问题？

| 问题 | 描述 |
|------|------|
| **代码分裂** | 不同对话中，AI 生成的代码没有复用，各自为政 |
| **重复编码** | 相同逻辑在不同组件中被重复实现 |
| **遗忘参考** | 组件 A 已解决的 bug，在组件 B 中又重复出现 |
| **重回起点** | 每次新对话都要重新理解项目，效果时好时坏 |
| **幻觉反复** | AI 自以为是地注入或依赖未实现的组件 |

**Projector 的解决方案**: 创建一个结构化的项目知识库，让 AI 在每次对话开始时就能快速、准确地理解项目上下文。

## 安装

### 方式一：一键安装（推荐）

```bash
cd your-project
git clone https://github.com/jeanhua/projector-skill.git .claude/skills/projector
```

### 方式二：Git Submodule

```bash
cd your-project
git submodule add https://github.com/jeanhua/projector-skill.git .claude/skills/projector
```

### 方式三：全局安装

```bash
git clone https://github.com/jeanhua/projector-skill.git ~/.claude/skills/projector
```

## 快速开始

### 1. 安装 Projector

按照上方的安装方式，将 projector 放入 `.claude/skills/` 目录。

### 2. 初始化知识库

在 Claude Code 中运行：

```
/projector init
```

### 3. 查看生成的文件

```
your-project/
├── CLAUDE.md              # 项目记忆文件
├── agent.md               # 项目专家代理
└── PROJECTOR/             # 项目知识库
    ├── README.md          # 使用指南
    ├── architecture/      # 架构文档
    ├── modules/           # 模块文档
    ├── patterns/          # 代码模式
    ├── issues/            # 问题记录
    └── context/           # 上下文信息
```

### 4. 开始使用

现在，每次新对话开始时，AI 会自动查阅 `PROJECTOR/` 文件夹，快速理解项目上下文。

## 工作原理

```
┌─────────────────────────────────────────────────────────────┐
│                      /projector init                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  1. 扫描项目结构                                             │
│     - 识别技术栈 (React, Vue, Python, Rust...)               │
│     - 分析模块关系                                           │
│     - 检测代码复用机会                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  2. 生成知识库                                               │
│     - CLAUDE.md (引导 AI 查询知识库)                         │
│     - PROJECTOR/ (结构化项目知识)                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  3. 安装 Git Hook (可选)                                     │
│     - post-commit: 提交后提示更新                            │
│     - pre-commit: 提交前检查知识库                           │
└─────────────────────────────────────────────────────────────┘
```

### AI 如何使用知识库

```
新对话开始
    │
    ▼
读取 CLAUDE.md
    │
    ▼
发现 PROJECTOR/ 引导
    │
    ▼
查阅 PROJECTOR/README.md
    │
    ├─→ 架构问题? → 查阅 architecture/
    ├─→ 模块问题? → 查阅 modules/
    ├─→ 复用代码? → 查阅 patterns/reusable.md
    ├─→ 遇到问题? → 查阅 issues/
    └─→ 技术决策? → 查阅 context/decisions.md
```

## 功能特性

### 知识库结构

```
PROJECTOR/
├── README.md              # 项目总览和使用指南
├── architecture/
│   ├── overview.md        # 系统架构概述
│   ├── modules.md         # 模块依赖关系 (Mermaid 图)
│   └── data-flow.md       # 数据流图
├── modules/
│   └── <module>.md        # 每个模块的详细文档
├── patterns/
│   ├── reusable.md        # 可复用代码清单
│   ├── conventions.md     # 编码约定
│   └── anti-patterns.md   # 需要避免的反模式
├── issues/
│   ├── resolved.md        # 已解决的问题
│   ├── known-issues.md    # 已知问题
│   └── workarounds.md     # 临时解决方案
└── context/
    ├── decisions.md       # 技术决策记录
    ├── dependencies.md    # 依赖关系
    └── environment.md     # 环境配置
```

### 智能语言检测

Projector 会自动检测项目文档的语言：

1. 扫描 `README.md`、`docs/` 等文档
2. 分析中文字符比例
3. 如果中文占比 > 30%，使用中文生成文档；否则使用英文

### Git Hook 集成

**post-commit hook** - 提交后自动提示：

```
╔════════════════════════════════════════════════════════════╗
║ Projector: 检测到以下模块需要更新文档:                         ║
╠════════════════════════════════════════════════════════════╣
║   - auth                                                   ║
║   - utils                                                  ║
╠════════════════════════════════════════════════════════════╣
║ 运行 /projector update 更新知识库                            ║
╚════════════════════════════════════════════════════════════╝
```

## 命令

| 命令 | 说明 |
|------|------|
| `/projector init` | 初始化项目知识库 |
| `/projector update` | 更新现有知识库（增量更新） |
| `/projector scan` | 扫描项目结构，输出分析报告 |

## 支持的语言和框架

Projector 是**通用的**，支持任何语言和框架。它通过扫描目录结构和配置文件来识别项目。

以下是已测试的语言和框架：

| 语言 | 常见框架/工具 |
|------|--------------|
| JavaScript/TypeScript | React, Vue, Angular, Next.js, Nuxt.js, Express, Fastify, Svelte |
| Python | Django, Flask, FastAPI, Streamlit |
| Rust | Actix, Rocket, Axum |
| Go | Gin, Echo, Fiber |
| Java | Spring Boot, Maven, Gradle |
| Ruby | Rails, Sinatra |
| C# | .NET, ASP.NET |
| PHP | Laravel, Symfony |
| Swift | Vapor |
| Kotlin | Ktor |

即使你的项目不在上述列表中，Projector 仍然可以正常工作。它会：
- 自动识别项目根目录的配置文件
- 扫描源代码目录结构
- 分析模块和组件关系

## 自定义配置

### 修改模板

模板文件位于 `templates/` 目录，可以根据项目需求进行修改：

```bash
# 如果是 clone 到 .claude/skills/projector
vim .claude/skills/projector/templates/README-zh.md
vim .claude/skills/projector/templates/README-en.md
vim .claude/skills/projector/templates/modules/module-template.md
```

### 添加新的知识类别

1. 在 `templates/` 目录创建新的模板文件
2. 修改 `SKILL.md` 中的执行流程
3. 更新 `scripts/generate-docs.sh` 脚本

## 最佳实践

### 保持知识库更新

- 每次重大变更后运行 `/projector update`
- 定期检查知识库的准确性
- 及时更新过时的信息

### 团队协作

- 将 `PROJECTOR/` 纳入版本控制
- 团队成员共同维护知识库
- 定期 review 知识库内容

### 记录重要信息

- 解决问题后及时记录到 `issues/resolved.md`
- 发现可复用代码及时添加到 `patterns/reusable.md`
- 做出技术决策及时记录到 `context/decisions.md`

## FAQ

### Q: 语言检测不准确怎么办？

A: 检查 `README.md` 是否包含足够的文本，确保使用 UTF-8 编码。

### Q: Git hook 不工作怎么办？

A: 检查 hook 文件是否有执行权限：
```bash
chmod +x .claude/skills/projector/hooks/*
```

### Q: 知识库文件应该提交到 Git 吗？

A: 是的，建议将 `PROJECTOR/` 纳入版本控制，这样团队成员可以共享知识库。

## 贡献

欢迎贡献代码和改进建议！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

<p align="center">
  如果这个项目对你有帮助，请给一个 ⭐️
</p>
