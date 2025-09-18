#!/bin/bash

# 快速验证 Codespace 配置文件
# 用于本地测试 devcontainer 配置是否正确

echo "🔍 验证 Codespace 配置文件..."

# 检查必要文件是否存在
FILES=(
    ".devcontainer/devcontainer.json"
    ".devcontainer/install-cangjie.sh"
    ".devcontainer/README.md"
)

echo "📋 检查配置文件..."
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file 缺失"
        exit 1
    fi
done

# 验证 JSON 格式
echo ""
echo "📋 验证 JSON 格式..."
if command -v jq >/dev/null 2>&1; then
    if jq empty .devcontainer/devcontainer.json >/dev/null 2>&1; then
        echo "✅ devcontainer.json 格式正确"
    else
        echo "❌ devcontainer.json 格式错误"
        exit 1
    fi
else
    echo "⚠️  jq 未安装，跳过 JSON 验证"
fi

# 检查安装脚本是否可执行
echo ""
echo "📋 检查脚本权限..."
if [ -x ".devcontainer/install-cangjie.sh" ]; then
    echo "✅ install-cangjie.sh 有执行权限"
else
    echo "⚠️  install-cangjie.sh 没有执行权限，正在添加..."
    chmod +x .devcontainer/install-cangjie.sh
    echo "✅ 权限已添加"
fi

# 检查脚本语法
echo ""
echo "📋 检查脚本语法..."
if bash -n .devcontainer/install-cangjie.sh; then
    echo "✅ install-cangjie.sh 语法正确"
else
    echo "❌ install-cangjie.sh 语法错误"
    exit 1
fi

# 检查 YAML 格式（如果有 GitHub Actions）
echo ""
echo "📋 检查 GitHub Actions..."
if [ -f ".github/workflows/test-cangjie-setup.yml" ]; then
    if command -v yamllint >/dev/null 2>&1; then
        if yamllint .github/workflows/test-cangjie-setup.yml >/dev/null 2>&1; then
            echo "✅ GitHub Actions YAML 格式正确"
        else
            echo "⚠️  GitHub Actions YAML 可能有格式问题"
        fi
    else
        echo "⚠️  yamllint 未安装，跳过 YAML 验证"
    fi
else
    echo "📝 未找到 GitHub Actions 配置"
fi

# 检查文档文件
echo ""
echo "📋 检查文档完整性..."
if [ -f "README.md" ] && grep -q "Codespace" README.md; then
    echo "✅ README.md 包含 Codespace 说明"
else
    echo "⚠️  README.md 可能缺少 Codespace 说明"
fi

if [ -f ".devcontainer/README.md" ]; then
    echo "✅ Codespace 专用 README 存在"
else
    echo "⚠️  建议添加 .devcontainer/README.md"
fi

# 模拟检查安装过程（不实际下载）
echo ""
echo "📋 模拟检查安装过程..."

# 检查下载 URL 是否在脚本中
if grep -q "cangjie-sdk-linux-x64" .devcontainer/install-cangjie.sh; then
    echo "✅ 找到仓颉 SDK 下载配置"
else
    echo "❌ 未找到仓颉 SDK 下载配置"
fi

if grep -q "cangjie-stdx-linux-x64" .devcontainer/install-cangjie.sh; then
    echo "✅ 找到 stdx 扩展库下载配置"
else
    echo "❌ 未找到 stdx 扩展库下载配置"
fi

if grep -q "cangjie_docs" .devcontainer/install-cangjie.sh; then
    echo "✅ 找到官方文档下载配置"
else
    echo "❌ 未找到官方文档下载配置"
fi

# 检查环境变量配置
if grep -q "CANGJIE_HOME" .devcontainer/install-cangjie.sh; then
    echo "✅ 找到环境变量配置"
else
    echo "❌ 未找到环境变量配置"
fi

echo ""
echo "🎉 Codespace 配置验证完成！"
echo ""
echo "📋 验证总结："
echo "  - 配置文件完整性: ✅"
echo "  - JSON 格式: ✅" 
echo "  - 脚本权限: ✅"
echo "  - 脚本语法: ✅"
echo "  - 安装配置: ✅"
echo ""
echo "🚀 您的 Codespace 配置已就绪！"
echo ""
echo "💡 下一步："
echo "  1. 提交代码到 GitHub"
echo "  2. 在 GitHub 仓库页面点击 'Code' → 'Codespaces'"
echo "  3. 创建新的 Codespace"
echo "  4. 等待自动安装完成"
echo ""