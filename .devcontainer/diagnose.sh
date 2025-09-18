#!/usr/bin/env bash

# 仓颉环境诊断脚本
# 用于检查安装状态和诊断问题

echo "🔍 仓颉环境诊断报告"
echo "==================="
echo "时间: $(date)"
echo ""

# 检查基本系统信息
echo "📋 系统信息"
echo "----------"
echo "操作系统: $(uname -a)"
echo "用户: $(whoami)"
echo "当前目录: $(pwd)"
echo "Shell: $SHELL"
echo ""

# 检查网络连接
echo "🌐 网络连接测试"
echo "-------------"
if ping -c 1 gitcode.com >/dev/null 2>&1; then
    echo "✅ GitCode 连接正常"
else
    echo "❌ GitCode 连接失败"
fi

if ping -c 1 cangjie-lang.cn >/dev/null 2>&1; then
    echo "✅ 仓颉官网连接正常"
else
    echo "❌ 仓颉官网连接失败"
fi
echo ""

# 检查安装目录
echo "📁 安装目录检查"
echo "-------------"
if [ -d "/opt/cangjie" ]; then
    echo "✅ /opt/cangjie 存在"
    ls -la /opt/cangjie/ 2>/dev/null || echo "  (无法列出内容)"
else
    echo "❌ /opt/cangjie 不存在"
fi

if [ -d "/opt/cangjie-stdx" ]; then
    echo "✅ /opt/cangjie-stdx 存在"
    ls -la /opt/cangjie-stdx/ 2>/dev/null || echo "  (无法列出内容)"
else
    echo "❌ /opt/cangjie-stdx 不存在"
fi

if [ -d "/opt/cangjie-docs" ]; then
    echo "✅ /opt/cangjie-docs 存在"
    ls -la /opt/cangjie-docs/ 2>/dev/null || echo "  (无法列出内容)"
else
    echo "❌ /opt/cangjie-docs 不存在"
fi
echo ""

# 检查仓颉编译器
echo "🔧 仓颉工具检查"
echo "-------------"
if [ -x "/opt/cangjie/cangjie-1.0.1/bin/cjc" ]; then
    echo "✅ 仓颉编译器已安装"
    VERSION_OUTPUT=$(/opt/cangjie/cangjie-1.0.1/bin/cjc -v 2>&1 || echo "版本检查失败")
    echo "  版本: $VERSION_OUTPUT"
else
    echo "❌ 仓颉编译器未找到"
fi

if command -v cjc >/dev/null 2>&1; then
    echo "✅ cjc 在 PATH 中"
else
    echo "❌ cjc 不在 PATH 中"
fi

if command -v cjpm >/dev/null 2>&1; then
    echo "✅ cjpm 在 PATH 中"
else
    echo "❌ cjpm 不在 PATH 中"
fi
echo ""

# 检查环境变量
echo "🔧 环境变量"
echo "----------"
echo "CANGJIE_HOME: ${CANGJIE_HOME:-未设置}"
echo "PATH: $PATH"
echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH:-未设置}"
echo ""

# 检查配置文件
echo "📄 配置文件检查"
echo "-------------"
if [ -f ~/.bashrc ]; then
    if grep -q "CANGJIE_HOME" ~/.bashrc; then
        echo "✅ ~/.bashrc 包含仓颉配置"
    else
        echo "❌ ~/.bashrc 缺少仓颉配置"
    fi
else
    echo "❌ ~/.bashrc 不存在"
fi

if [ -f ~/.zshrc ]; then
    if grep -q "CANGJIE_HOME" ~/.zshrc; then
        echo "✅ ~/.zshrc 包含仓颉配置"
    else
        echo "❌ ~/.zshrc 缺少仓颉配置"
    fi
else
    echo "📝 ~/.zshrc 不存在（正常）"
fi
echo ""

# 检查安装脚本
echo "📜 安装脚本检查"
echo "-------------"
if [ -f ".devcontainer/install-cangjie.sh" ]; then
    if [ -x ".devcontainer/install-cangjie.sh" ]; then
        echo "✅ 主安装脚本存在且可执行"
    else
        echo "⚠️  主安装脚本存在但不可执行"
    fi
else
    echo "❌ 主安装脚本不存在"
fi

if [ -f ".devcontainer/fallback-install.sh" ]; then
    if [ -x ".devcontainer/fallback-install.sh" ]; then
        echo "✅ 备用安装脚本存在且可执行"
    else
        echo "⚠️  备用安装脚本存在但不可执行"
    fi
else
    echo "❌ 备用安装脚本不存在"
fi
echo ""

# 检查示例项目
echo "📝 示例项目检查"
echo "-------------"
if [ -d "~/cangjie-examples" ]; then
    echo "✅ 示例项目目录存在"
    find ~/cangjie-examples -type f -name "*.cj" | head -5 | while read file; do
        echo "  发现: $file"
    done
else
    echo "❌ 示例项目目录不存在"
fi
echo ""

# 磁盘使用情况
echo "💾 磁盘使用"
echo "----------"
df -h /opt/ 2>/dev/null || echo "无法获取 /opt/ 磁盘信息"
du -sh /opt/cangjie* 2>/dev/null || echo "无法获取仓颉安装大小"
echo ""

# 检查最近的错误日志
echo "📋 建议的修复步骤"
echo "---------------"
echo "1. 如果网络连接有问题，请检查代理设置"
echo "2. 如果安装目录缺失，运行: sudo mkdir -p /opt/cangjie /opt/cangjie-stdx /opt/cangjie-docs"
echo "3. 如果权限有问题，运行: sudo chown -R codespace:codespace /opt/cangjie*"
echo "4. 重新运行安装脚本: ./.devcontainer/install-cangjie.sh"
echo "5. 如果主脚本失败，尝试备用脚本: ./.devcontainer/fallback-install.sh"
echo ""

echo "诊断完成。如需详细帮助，请查看 .devcontainer/README.md"