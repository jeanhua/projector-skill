# 项目知识库

> 本文件夹由 projector skill 生成，包含项目的结构化知识文档。
> AI 在每次对话中应首先查阅此文件夹以快速理解项目。

## 快速导航

- [架构概述](architecture/overview.md) - 系统整体架构
- [模块依赖](architecture/modules.md) - 模块间依赖关系
- [数据流](architecture/data-flow.md) - 数据流向图
- [模块文档](modules/) - 各模块详细说明
- [代码模式](patterns/) - 可复用代码和约定
- [问题记录](issues/) - 已知问题和解决方案
- [技术决策](context/decisions.md) - 重要决策记录
- [依赖关系](context/dependencies.md) - 项目依赖
- [环境配置](context/environment.md) - 环境要求

## 使用指南

### 新对话开始时

1. 阅读本 README 了解项目概况
2. 查看 `architecture/overview.md` 了解系统架构
3. 根据任务需要，查阅相关模块的文档

### 修改代码前

1. 查阅 `modules/` 中对应模块的文档
2. 检查 `patterns/reusable.md` 是否有可复用的代码
3. 查看 `patterns/conventions.md` 了解编码约定
4. 检查 `issues/known-issues.md` 是否有相关已知问题

### 遇到问题时

1. 检查 `issues/resolved.md` 是否有已知解决方案
2. 查看 `issues/workarounds.md` 是否有临时解决方案
3. 检查 `context/decisions.md` 了解相关技术决策

### 编写新代码时

1. 参考 `patterns/conventions.md` 中的编码约定
2. 优先复用 `patterns/reusable.md` 中的现有代码
3. 避免使用 `patterns/anti-patterns.md` 中的反模式
4. 将新发现的可复用代码添加到 `patterns/reusable.md`

### 解决问题后

1. 将问题和解决方案添加到 `issues/resolved.md`
2. 如果是通用解决方案，考虑添加到 `patterns/reusable.md`
3. 更新相关模块的文档

## 更新知识库

### 自动更新

项目配置了 Git hook，会在每次提交后自动检测变更并提示更新。

### 手动更新

运行 `/projector update` 命令手动更新知识库。

### 更新内容

- 模块文档：当模块代码发生变更时
- 可复用代码：当发现新的可复用代码时
- 已知问题：当发现或解决新问题时
- 架构文档：当架构发生重大变更时

## 知识库结构

```
PROJECTOR/
├── README.md              # 本文件 - 项目总览和使用指南
├── architecture/          # 架构文档
│   ├── overview.md        # 系统架构概述
│   ├── modules.md         # 模块依赖关系
│   └── data-flow.md       # 数据流图
├── modules/               # 模块详细文档
│   └── <module>.md        # 每个模块的文档
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

## 注意事项

1. **保持更新**: 知识库需要定期更新以保持准确性
2. **手动编辑**: 可以手动编辑知识库文件，但注意保持格式一致
3. **增量更新**: 使用 `/projector update` 会保留手动编辑的内容
4. **版本控制**: 建议将 PROJECTOR/ 文件夹纳入版本控制
5. **团队协作**: 团队成员应共同维护知识库

---

*最后更新: [日期]*
*由 projector skill 生成*
