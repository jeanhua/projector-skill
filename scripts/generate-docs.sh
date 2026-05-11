#!/bin/bash
# generate-docs.sh
# 生成 PROJECTOR/ 文档

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"

# 项目根目录
PROJECT_ROOT="${1:-.}"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${GREEN}Projector 文档生成器${NC}                                      ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查目录是否存在
if [ ! -d "$PROJECT_ROOT" ]; then
    echo -e "${RED}错误: 目录 '$PROJECT_ROOT' 不存在${NC}"
    exit 1
fi

cd "$PROJECT_ROOT" || exit 1

# 检查是否已存在 PROJECTOR/ 目录
if [ -d "PROJECTOR" ]; then
    echo -e "${YELLOW}警告: PROJECTOR/ 目录已存在${NC}"
    read -p "是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}操作已取消${NC}"
        exit 0
    fi
fi

# 检测语言
echo -e "${BLUE}检测项目语言...${NC}"
LANGUAGE=$(python3 "$SCRIPT_DIR/detect-language.py" "$PROJECT_ROOT")
echo -e "  - 检测结果: ${GREEN}$LANGUAGE${NC}"

# 创建目录结构
echo -e "${BLUE}创建目录结构...${NC}"
mkdir -p PROJECTOR/{architecture,modules,patterns,issues,context}

# 复制模板文件
echo -e "${BLUE}生成文档文件...${NC}"

# README.md
if [ "$LANGUAGE" = "zh" ]; then
    cp "$TEMPLATES_DIR/README-zh.md" PROJECTOR/README.md
else
    cp "$TEMPLATES_DIR/README-en.md" PROJECTOR/README.md
fi
echo -e "  - ${GREEN}PROJECTOR/README.md${NC}"

# architecture/
cp "$TEMPLATES_DIR/architecture/overview.md" PROJECTOR/architecture/overview.md
cp "$TEMPLATES_DIR/architecture/modules.md" PROJECTOR/architecture/modules.md
cp "$TEMPLATES_DIR/architecture/data-flow.md" PROJECTOR/architecture/data-flow.md
echo -e "  - ${GREEN}PROJECTOR/architecture/${NC}"

# patterns/
cp "$TEMPLATES_DIR/patterns/reusable.md" PROJECTOR/patterns/reusable.md
cp "$TEMPLATES_DIR/patterns/conventions.md" PROJECTOR/patterns/conventions.md
cp "$TEMPLATES_DIR/patterns/anti-patterns.md" PROJECTOR/patterns/anti-patterns.md
echo -e "  - ${GREEN}PROJECTOR/patterns/${NC}"

# issues/
cp "$TEMPLATES_DIR/issues/resolved.md" PROJECTOR/issues/resolved.md
cp "$TEMPLATES_DIR/issues/known-issues.md" PROJECTOR/issues/known-issues.md
cp "$TEMPLATES_DIR/issues/workarounds.md" PROJECTOR/issues/workarounds.md
echo -e "  - ${GREEN}PROJECTOR/issues/${NC}"

# context/
cp "$TEMPLATES_DIR/context/decisions.md" PROJECTOR/context/decisions.md
cp "$TEMPLATES_DIR/context/dependencies.md" PROJECTOR/context/dependencies.md
cp "$TEMPLATES_DIR/context/environment.md" PROJECTOR/context/environment.md
echo -e "  - ${GREEN}PROJECTOR/context/${NC}"

# 生成模块文档
echo -e "${BLUE}生成模块文档...${NC}"

# 检测主要模块
MODULES=()
if [ -d "src" ]; then
    for module in src/*/; do
        if [ -d "$module" ]; then
            module_name=$(basename "$module")
            # 跳过特殊目录
            if [[ "$module_name" != "__tests__" ]] && [[ "$module_name" != "test" ]]; then
                MODULES+=("$module_name")
            fi
        fi
    done
elif [ -d "lib" ]; then
    for module in lib/*/; do
        if [ -d "$module" ]; then
            module_name=$(basename "$module")
            if [[ "$module_name" != "__tests__" ]] && [[ "$module_name" != "test" ]]; then
                MODULES+=("$module_name")
            fi
        fi
    done
fi

# 为每个模块生成文档
for module in "${MODULES[@]}"; do
    cp "$TEMPLATES_DIR/modules/module-template.md" "PROJECTOR/modules/$module.md"
    # 替换模块名称
    sed -i "s/\[模块名称\]/$module/g" "PROJECTOR/modules/$module.md"
    echo -e "  - ${GREEN}PROJECTOR/modules/$module.md${NC}"
done

# 生成 CLAUDE.md
echo -e "${BLUE}生成 CLAUDE.md...${NC}"
if [ -f "CLAUDE.md" ]; then
    echo -e "${YELLOW}警告: CLAUDE.md 已存在${NC}"
    read -p "是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$TEMPLATES_DIR/CLAUDE.md" CLAUDE.md
        echo -e "  - ${GREEN}CLAUDE.md${NC}"
    else
        echo -e "  - ${YELLOW}跳过 CLAUDE.md${NC}"
    fi
else
    cp "$TEMPLATES_DIR/CLAUDE.md" CLAUDE.md
    echo -e "  - ${GREEN}CLAUDE.md${NC}"
fi

# 生成 agent.md
echo -e "${BLUE}生成 agent.md...${NC}"
if [ -f "agent.md" ]; then
    echo -e "${YELLOW}警告: agent.md 已存在${NC}"
    read -p "是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$TEMPLATES_DIR/agent.md" agent.md
        echo -e "  - ${GREEN}agent.md${NC}"
    else
        echo -e "  - ${YELLOW}跳过 agent.md${NC}"
    fi
else
    cp "$TEMPLATES_DIR/agent.md" agent.md
    echo -e "  - ${GREEN}agent.md${NC}"
fi

echo ""

# 询问是否安装 Git hooks
if [ -d ".git" ]; then
    echo -e "${BLUE}检测到 Git 仓库${NC}"
    read -p "是否安装 Git hooks? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/setup-hooks.sh"
    fi
fi

echo ""

# 生成摘要
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ${GREEN}文档生成完成!${NC}                                             ${GREEN}║${NC}"
echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC} ${BLUE}生成的文件:${NC}                                               ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   - CLAUDE.md                                              ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   - agent.md                                               ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   - PROJECTOR/                                             ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - README.md                                            ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - architecture/ (3 个文件)                              ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - modules/ (${#MODULES[@]} 个文件)                               ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - patterns/ (3 个文件)                                  ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - issues/ (3 个文件)                                    ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}     - context/ (3 个文件)                                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}                                                          ${GREEN}║${NC}"
echo -e "${GREEN}║${NC} ${BLUE}下一步:${NC}                                                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   1. 编辑 CLAUDE.md 添加项目特定信息                        ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   2. 编辑 PROJECTOR/ 中的文档填充具体内容                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   3. 运行 /projector update 更新知识库                      ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
