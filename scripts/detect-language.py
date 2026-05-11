#!/usr/bin/env python3
"""
语言检测脚本
检测项目文档的主要语言（中文/英文）
"""

import os
import re
import sys
import json
from pathlib import Path


def detect_chinese_ratio(text: str) -> float:
    """
    检测文本中中文字符的比例

    Args:
        text: 要检测的文本

    Returns:
        中文字符的比例 (0.0 - 1.0)
    """
    if not text:
        return 0.0

    # 统计中文字符（CJK统一汉字）
    chinese_chars = len(re.findall(r'[一-鿿]', text))
    # 统计总字符（排除空白字符）
    total_chars = len(re.findall(r'\S', text))

    if total_chars == 0:
        return 0.0

    return chinese_chars / total_chars


def read_file_content(file_path: str) -> str:
    """
    读取文件内容

    Args:
        file_path: 文件路径

    Returns:
        文件内容，如果文件不存在或无法读取则返回空字符串
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except (FileNotFoundError, PermissionError, UnicodeDecodeError):
        return ""


def detect_from_readme(project_root: str) -> tuple[str, float]:
    """
    从 README.md 检测语言

    Args:
        project_root: 项目根目录

    Returns:
        (语言代码, 置信度)
    """
    readme_path = os.path.join(project_root, "README.md")
    content = read_file_content(readme_path)

    if not content:
        return ("en", 0.0)

    ratio = detect_chinese_ratio(content)

    if ratio > 0.3:
        return ("zh", ratio)
    else:
        return ("en", 1.0 - ratio)


def detect_from_docs(project_root: str) -> tuple[str, float]:
    """
    从 docs/ 目录检测语言

    Args:
        project_root: 项目根目录

    Returns:
        (语言代码, 置信度)
    """
    docs_dir = os.path.join(project_root, "docs")
    if not os.path.isdir(docs_dir):
        return ("en", 0.0)

    total_content = ""
    for root, dirs, files in os.walk(docs_dir):
        for file in files:
            if file.endswith(('.md', '.txt', '.rst')):
                file_path = os.path.join(root, file)
                total_content += read_file_content(file_path)

    if not total_content:
        return ("en", 0.0)

    ratio = detect_chinese_ratio(total_content)

    if ratio > 0.3:
        return ("zh", ratio)
    else:
        return ("en", 1.0 - ratio)


def detect_from_package_json(project_root: str) -> tuple[str, float]:
    """
    从 package.json 检测语言

    Args:
        project_root: 项目根目录

    Returns:
        (语言代码, 置信度)
    """
    package_json_path = os.path.join(project_root, "package.json")
    content = read_file_content(package_json_path)

    if not content:
        return ("en", 0.0)

    try:
        data = json.loads(content)
        description = data.get("description", "")
        if description:
            ratio = detect_chinese_ratio(description)
            if ratio > 0.3:
                return ("zh", ratio)
    except json.JSONDecodeError:
        pass

    return ("en", 0.0)


def detect_from_pyproject_toml(project_root: str) -> tuple[str, float]:
    """
    从 pyproject.toml 检测语言

    Args:
        project_root: 项目根目录

    Returns:
        (语言代码, 置信度)
    """
    pyproject_path = os.path.join(project_root, "pyproject.toml")
    content = read_file_content(pyproject_path)

    if not content:
        return ("en", 0.0)

    # 提取 description 字段
    match = re.search(r'description\s*=\s*"([^"]*)"', content)
    if match:
        description = match.group(1)
        ratio = detect_chinese_ratio(description)
        if ratio > 0.3:
            return ("zh", ratio)

    return ("en", 0.0)


def detect_language(project_root: str) -> str:
    """
    检测项目文档的主要语言

    Args:
        project_root: 项目根目录

    Returns:
        语言代码 ("zh" 或 "en")
    """
    # 收集所有检测结果
    results = []

    # 1. 从 README.md 检测
    readme_lang, readme_confidence = detect_from_readme(project_root)
    if readme_confidence > 0:
        results.append((readme_lang, readme_confidence, "README.md"))

    # 2. 从 docs/ 目录检测
    docs_lang, docs_confidence = detect_from_docs(project_root)
    if docs_confidence > 0:
        results.append((docs_lang, docs_confidence, "docs/"))

    # 3. 从 package.json 检测
    package_lang, package_confidence = detect_from_package_json(project_root)
    if package_confidence > 0:
        results.append((package_lang, package_confidence, "package.json"))

    # 4. 从 pyproject.toml 检测
    pyproject_lang, pyproject_confidence = detect_from_pyproject_toml(project_root)
    if pyproject_confidence > 0:
        results.append((pyproject_lang, pyproject_confidence, "pyproject.toml"))

    # 如果没有检测结果，默认使用英文
    if not results:
        return "en"

    # 统计中文和英文的投票
    zh_votes = sum(confidence for lang, confidence, _ in results if lang == "zh")
    en_votes = sum(confidence for lang, confidence, _ in results if lang == "en")

    # 返回得票最高的语言
    if zh_votes > en_votes:
        return "zh"
    else:
        return "en"


def main():
    """
    主函数
    """
    # 获取项目根目录
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        project_root = os.getcwd()

    # 验证目录是否存在
    if not os.path.isdir(project_root):
        print(f"错误: 目录 '{project_root}' 不存在", file=sys.stderr)
        sys.exit(1)

    # 检测语言
    language = detect_language(project_root)

    # 输出结果
    print(language)


if __name__ == "__main__":
    main()
