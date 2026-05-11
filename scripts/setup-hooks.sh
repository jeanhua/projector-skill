#!/bin/bash
# setup-hooks.sh
# 安装 projector Git hooks

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$(dirname "$SCRIPT_DIR")/hooks"

# 项目根目录
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${GREEN}Projector Git Hooks 安装程序${NC}                              ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查是否是 git 仓库
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${RED}错误: 当前目录不是 git 仓库${NC}"
    exit 1
fi

# 创建 hooks 目录（如果不存在）
mkdir -p "$PROJECT_ROOT/.git/hooks"

# 安装 post-commit hook
echo -e "${BLUE}安装 post-commit hook...${NC}"
if [ -f "$PROJECT_ROOT/.git/hooks/post-commit" ]; then
    echo -e "${YELLOW}警告: post-commit hook 已存在${NC}"
    read -p "是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$HOOKS_DIR/post-commit" "$PROJECT_ROOT/.git/hooks/post-commit"
        chmod +x "$PROJECT_ROOT/.git/hooks/post-commit"
        echo -e "${GREEN}✓ post-commit hook 已安装${NC}"
    else
        echo -e "${YELLOW}跳过 post-commit hook${NC}"
    fi
else
    cp "$HOOKS_DIR/post-commit" "$PROJECT_ROOT/.git/hooks/post-commit"
    chmod +x "$PROJECT_ROOT/.git/hooks/post-commit"
    echo -e "${GREEN}✓ post-commit hook 已安装${NC}"
fi

# 安装 pre-commit hook
echo -e "${BLUE}安装 pre-commit hook...${NC}"
if [ -f "$PROJECT_ROOT/.git/hooks/pre-commit" ]; then
    echo -e "${YELLOW}警告: pre-commit hook 已存在${NC}"
    read -p "是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$HOOKS_DIR/pre-commit" "$PROJECT_ROOT/.git/hooks/pre-commit"
        chmod +x "$PROJECT_ROOT/.git/hooks/pre-commit"
        echo -e "${GREEN}✓ pre-commit hook 已安装${NC}"
    else
        echo -e "${YELLOW}跳过 pre-commit hook${NC}"
    fi
else
    cp "$HOOKS_DIR/pre-commit" "$PROJECT_ROOT/.git/hooks/pre-commit"
    chmod +x "$PROJECT_ROOT/.git/hooks/pre-commit"
    echo -e "${GREEN}✓ pre-commit hook 已安装${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ${GREEN}安装完成!${NC}                                                ${GREEN}║${NC}"
echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC} ${BLUE}已安装的 hooks:${NC}                                           ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   - post-commit: 提交后提示更新知识库                       ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   - pre-commit: 提交前检查知识库是否更新                    ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}                                                          ${GREEN}║${NC}"
echo -e "${GREEN}║${NC} ${BLUE}使用方法:${NC}                                                 ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   1. 提交代码后，会自动提示需要更新的模块                   ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   2. 运行 /projector update 更新知识库                      ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   3. 提交知识库变更                                        ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
