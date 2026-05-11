#!/bin/bash
# analyze-project.sh
# 分析项目结构，输出项目信息

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="${1:-.}"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${GREEN}Projector 项目分析${NC}                                        ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 检查目录是否存在
if [ ! -d "$PROJECT_ROOT" ]; then
    echo -e "${RED}错误: 目录 '$PROJECT_ROOT' 不存在${NC}"
    exit 1
fi

cd "$PROJECT_ROOT" || exit 1

# 1. 检测技术栈
echo -e "${CYAN}━━━ 技术栈检测 ━━━${NC}"

# 检测语言
echo -e "${BLUE}语言:${NC}"
if [ -f "package.json" ]; then
    echo -e "  - ${GREEN}JavaScript/TypeScript${NC} (检测到 package.json)"
fi
if [ -f "tsconfig.json" ]; then
    echo -e "  - ${GREEN}TypeScript${NC} (检测到 tsconfig.json)"
fi
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    echo -e "  - ${GREEN}Python${NC}"
fi
if [ -f "Cargo.toml" ]; then
    echo -e "  - ${GREEN}Rust${NC} (检测到 Cargo.toml)"
fi
if [ -f "go.mod" ]; then
    echo -e "  - ${GREEN}Go${NC} (检测到 go.mod)"
fi
if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    echo -e "  - ${GREEN}Java${NC}"
fi
if [ -f "Gemfile" ]; then
    echo -e "  - ${GREEN}Ruby${NC} (检测到 Gemfile)"
fi

# 检测框架
echo -e "${BLUE}框架:${NC}"
if [ -f "package.json" ]; then
    if grep -q "react" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}React${NC}"
    fi
    if grep -q "vue" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Vue${NC}"
    fi
    if grep -q "angular" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Angular${NC}"
    fi
    if grep -q "next" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Next.js${NC}"
    fi
    if grep -q "nuxt" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Nuxt.js${NC}"
    fi
    if grep -q "express" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Express${NC}"
    fi
    if grep -q "fastify" package.json 2>/dev/null; then
        echo -e "  - ${GREEN}Fastify${NC}"
    fi
fi

# 检测构建工具
echo -e "${BLUE}构建工具:${NC}"
if [ -f "webpack.config.js" ]; then
    echo -e "  - ${GREEN}Webpack${NC}"
fi
if [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
    echo -e "  - ${GREEN}Vite${NC}"
fi
if [ -f "rollup.config.js" ]; then
    echo -e "  - ${GREEN}Rollup${NC}"
fi
if [ -f "esbuild.config.js" ]; then
    echo -e "  - ${GREEN}esbuild${NC}"
fi

echo ""

# 2. 分析目录结构
echo -e "${CYAN}━━━ 目录结构 ━━━${NC}"

# 排除的目录
EXCLUDE_DIRS="node_modules|.git|dist|build|__pycache__|.venv|venv|target|bin|obj"

# 列出主要目录
echo -e "${BLUE}主要目录:${NC}"
find . -maxdepth 1 -type d ! -name '.' | \
    grep -vE "^\./($EXCLUDE_DIRS)$" | \
    sort | \
    while read -r dir; do
        dir_name=$(basename "$dir")
        # 计算目录中的文件数量
        file_count=$(find "$dir" -type f | wc -l)
        echo -e "  - ${GREEN}$dir_name/${NC} ($file_count 个文件)"
    done

echo ""

# 3. 统计代码行数
echo -e "${CYAN}━━━ 代码统计 ━━━${NC}"

echo -e "${BLUE}按语言统计:${NC}"

# TypeScript/JavaScript
if [ -d "src" ] || [ -d "lib" ]; then
    ts_files=$(find . -name "*.ts" -o -name "*.tsx" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
    js_files=$(find . -name "*.js" -o -name "*.jsx" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
    if [ "$ts_files" -gt 0 ] || [ "$js_files" -gt 0 ]; then
        echo -e "  - TypeScript: ${GREEN}$ts_files${NC} 个文件"
        echo -e "  - JavaScript: ${GREEN}$js_files${NC} 个文件"
    fi
fi

# Python
py_files=$(find . -name "*.py" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
if [ "$py_files" -gt 0 ]; then
    echo -e "  - Python: ${GREEN}$py_files${NC} 个文件"
fi

# Rust
rs_files=$(find . -name "*.rs" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
if [ "$rs_files" -gt 0 ]; then
    echo -e "  - Rust: ${GREEN}$rs_files${NC} 个文件"
fi

# Go
go_files=$(find . -name "*.go" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
if [ "$go_files" -gt 0 ]; then
    echo -e "  - Go: ${GREEN}$go_files${NC} 个文件"
fi

echo ""

# 4. 检测配置文件
echo -e "${CYAN}━━━ 配置文件 ━━━${NC}"

echo -e "${BLUE}已检测到的配置文件:${NC}"
for config_file in package.json tsconfig.json .eslintrc.json .prettierrc.json \
                   jest.config.js vite.config.ts webpack.config.js \
                   requirements.txt pyproject.toml setup.py \
                   Cargo.toml go.mod pom.xml build.gradle \
                   .gitignore .env.example docker-compose.yml Dockerfile; do
    if [ -f "$config_file" ]; then
        echo -e "  - ${GREEN}$config_file${NC}"
    fi
done

echo ""

# 5. 检测模块
echo -e "${CYAN}━━━ 模块检测 ━━━${NC}"

echo -e "${BLUE}主要模块:${NC}"
if [ -d "src" ]; then
    find src -maxdepth 1 -type d ! -name "src" | sort | while read -r module; do
        module_name=$(basename "$module")
        file_count=$(find "$module" -type f | wc -l)
        echo -e "  - ${GREEN}$module_name${NC} ($file_count 个文件)"
    done
elif [ -d "lib" ]; then
    find lib -maxdepth 1 -type d ! -name "lib" | sort | while read -r module; do
        module_name=$(basename "$module")
        file_count=$(find "$module" -type f | wc -l)
        echo -e "  - ${GREEN}$module_name${NC} ($file_count 个文件)"
    done
fi

echo ""

# 6. 检测可复用代码
echo -e "${CYAN}━━━ 可复用代码检测 ━━━${NC}"

echo -e "${BLUE}工具函数/模块:${NC}"
for util_dir in utils helpers lib common shared; do
    if [ -d "$util_dir" ]; then
        echo -e "  - ${GREEN}$util_dir/${NC}"
        find "$util_dir" -maxdepth 1 -type f | head -5 | while read -r file; do
            file_name=$(basename "$file")
            echo -e "    - $file_name"
        done
    fi
done

echo ""

# 7. 检测 TODO/FIXME
echo -e "${CYAN}━━━ TODO/FIXME 检测 ━━━${NC}"

echo -e "${BLUE}代码中的 TODO/FIXME:${NC}"
grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.py" . 2>/dev/null | \
    grep -vE "($EXCLUDE_DIRS)" | \
    head -10 | \
    while read -r line; do
        echo -e "  ${YELLOW}$line${NC}"
    done

echo ""

# 8. 检测测试
echo -e "${CYAN}━━━ 测试检测 ━━━${NC}"

echo -e "${BLUE}测试文件:${NC}"
test_files=$(find . -name "*.test.*" -o -name "*.spec.*" -o -name "*_test.*" | grep -vE "($EXCLUDE_DIRS)" | wc -l)
echo -e "  - 测试文件数量: ${GREEN}$test_files${NC}"

if [ -d "tests" ] || [ -d "test" ] || [ -d "__tests__" ]; then
    echo -e "  - 测试目录: ${GREEN}存在${NC}"
else
    echo -e "  - 测试目录: ${YELLOW}未找到${NC}"
fi

echo ""

# 9. 检测 Git 信息
echo -e "${CYAN}━━━ Git 信息 ━━━${NC}"

if [ -d ".git" ]; then
    echo -e "${BLUE}Git 仓库:${NC}"
    echo -e "  - 分支: ${GREEN}$(git branch --show-current 2>/dev/null || echo 'unknown')${NC}"
    echo -e "  - 提交数: ${GREEN}$(git rev-list --count HEAD 2>/dev/null || echo 'unknown')${NC}"
    echo -e "  - 最后提交: ${GREEN}$(git log -1 --format='%ar' 2>/dev/null || echo 'unknown')${NC}"
else
    echo -e "${YELLOW}不是 Git 仓库${NC}"
fi

echo ""

# 10. 生成摘要
echo -e "${CYAN}━━━ 分析摘要 ━━━${NC}"

total_files=$(find . -type f | grep -vE "($EXCLUDE_DIRS)" | wc -l)
total_dirs=$(find . -type d | grep -vE "($EXCLUDE_DIRS)" | wc -l)

echo -e "${BLUE}项目统计:${NC}"
echo -e "  - 总文件数: ${GREEN}$total_files${NC}"
echo -e "  - 总目录数: ${GREEN}$total_dirs${NC}"
echo -e "  - 测试文件: ${GREEN}$test_files${NC}"

echo ""
echo -e "${GREEN}分析完成!${NC}"
echo ""
