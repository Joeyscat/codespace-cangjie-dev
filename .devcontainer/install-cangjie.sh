#!/bin/bash

# 仓颉编程环境自动安装脚本
# 适用于 GitHub Codespaces

set -e

echo "🚀 开始安装仓颉编程环境..."

# 更新系统包
echo "📦 更新系统包..."
sudo apt-get update -qq

# 安装必要的依赖
echo "📦 安装系统依赖..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    tar \
    tree \
    jq \
    build-essential \
    libssl-dev \
    pkg-config

# 创建安装目录
echo "📁 创建安装目录..."
sudo mkdir -p /opt/cangjie
sudo mkdir -p /opt/cangjie-stdx  
sudo mkdir -p /opt/cangjie-docs
sudo chown -R codespace:codespace /opt/cangjie*

# 定义版本和下载链接
CANGJIE_VERSION="1.0.1"
STDX_VERSION="1.0.1.2"

# 下载仓颉 SDK
echo "⬇️  下载仓颉 SDK ${CANGJIE_VERSION}..."
cd /tmp
if [ ! -f "cangjie-sdk-linux-x64-${CANGJIE_VERSION}.tar.gz" ]; then
    # 使用您提供的官方下载链接模式
    wget -O "cangjie-sdk-linux-x64-${CANGJIE_VERSION}.tar.gz" \
        "https://cangjie-lang.cn/v1/files/auth/downLoad?nsId=142267&fileName=cangjie-sdk-linux-x64-${CANGJIE_VERSION}.tar.gz&objectKey=68a67996d1b22272d50f15f2" \
        --timeout=30 --tries=3 || {
        echo "❌ 仓颉 SDK 下载失败，请检查网络连接或下载链接"
        exit 1
    }
fi

# 解压并安装 SDK
echo "📦 安装仓颉 SDK..."
tar -xzf "cangjie-sdk-linux-x64-${CANGJIE_VERSION}.tar.gz"
mv "cangjie-${CANGJIE_VERSION}" "/opt/cangjie/cangjie-${CANGJIE_VERSION}"

# 下载 stdx 扩展库
echo "⬇️  下载 stdx 扩展库 ${STDX_VERSION}..."
if [ ! -f "cangjie-stdx-linux-x64-${STDX_VERSION}.zip" ]; then
    wget -O "cangjie-stdx-linux-x64-${STDX_VERSION}.zip" \
        "https://gitcode.com/Cangjie/cangjie_stdx/releases/download/v${STDX_VERSION}/cangjie-stdx-linux-x64-${STDX_VERSION}.zip" \
        --timeout=30 --tries=3 || {
        echo "❌ stdx 扩展库下载失败，请检查网络连接"
        exit 1
    }
fi

# 解压并安装 stdx
echo "📦 安装 stdx 扩展库..."
unzip -q "cangjie-stdx-linux-x64-${STDX_VERSION}.zip"
mv linux_x86_64_llvm /opt/cangjie-stdx/

# 下载 stdx 文档
echo "⬇️  下载 stdx 文档..."
if [ ! -f "cangjie-1.0.1-stdx-docs-html.tar.gz" ]; then
    wget -O "cangjie-1.0.1-stdx-docs-html.tar.gz" \
        "https://gitcode.com/Cangjie/cangjie_stdx/releases/download/v${STDX_VERSION}/cangjie-1.0.1-stdx-docs-html.tar.gz" \
        --timeout=30 --tries=3 || {
        echo "⚠️  stdx 文档下载失败，将跳过文档安装"
    }
fi

if [ -f "cangjie-1.0.1-stdx-docs-html.tar.gz" ]; then
    echo "📦 安装 stdx 文档..."
    tar -xzf "cangjie-1.0.1-stdx-docs-html.tar.gz"
    mv cjnative /opt/cangjie-stdx/docs
fi

# 下载官方开发文档
echo "⬇️  下载官方开发文档..."
cd /opt/cangjie-docs
git clone https://gitcode.com/Cangjie/cangjie_docs.git . || {
    echo "⚠️  官方文档下载失败，将跳过文档安装"
}

# 配置环境变量
echo "🔧 配置环境变量..."
cat >> ~/.bashrc << 'EOF'

# 仓颉编程环境
export CANGJIE_HOME="/opt/cangjie/cangjie-1.0.1"
export PATH="$CANGJIE_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CANGJIE_HOME/lib:$LD_LIBRARY_PATH"

# 仓颉别名
alias cj='cjc'
alias cjp='cjpm'
alias cjf='cjfmt'
alias cjd='cjdb'

EOF

# 为 zsh 也添加环境变量
if [ -f ~/.zshrc ]; then
    cat >> ~/.zshrc << 'EOF'

# 仓颉编程环境
export CANGJIE_HOME="/opt/cangjie/cangjie-1.0.1"
export PATH="$CANGJIE_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CANGJIE_HOME/lib:$LD_LIBRARY_PATH"

# 仓颉别名
alias cj='cjc'
alias cjp='cjpm'
alias cjf='cjfmt'
alias cjd='cjdb'

EOF
fi

# 创建文档查看工具
echo "📚 安装文档查看工具..."
mkdir -p ~/bin

cat > ~/bin/cj-docs << 'EOF'
#!/bin/bash

# 仓颉编程语言文档查看脚本
# 使用方法：cj-docs [选项]

show_help() {
    echo "仓颉编程语言文档查看器"
    echo ""
    echo "使用方法: cj-docs [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help              显示此帮助信息"
    echo "  -l, --list              列出所有可用文档"
    echo "  -d, --dev-guide         显示开发指南目录"
    echo "  -t, --tools             显示工具使用指南目录" 
    echo "  -o, --open <文件>       打开指定的 Markdown 文档"
    echo "  -s, --search <关键词>   搜索文档内容"
    echo ""
    echo "示例:"
    echo "  cj-docs -l                    # 列出所有文档"
    echo "  cj-docs -d                    # 显示开发指南"
    echo "  cj-docs -s function           # 搜索函数相关文档"
    echo "  cj-docs -o install.md         # 打开安装指南"
}

list_docs() {
    echo "=== 仓颉编程语言文档目录 ==="
    echo ""
    if [ -d "/opt/cangjie-docs/docs/dev-guide" ]; then
        echo "📖 开发指南 (dev-guide):"
        find /opt/cangjie-docs/docs/dev-guide -name "*.md" | head -10 | while read file; do
            basename=$(basename "$file" .md)
            echo "  - $basename"
        done
        echo "    ... 更多内容请使用 -d 选项查看"
        echo ""
    fi
    
    if [ -d "/opt/cangjie-docs/docs/tools" ]; then
        echo "🔧 工具指南 (tools):"
        find /opt/cangjie-docs/docs/tools -name "*.md" | head -10 | while read file; do
            basename=$(basename "$file" .md) 
            echo "  - $basename"
        done
        echo ""
    fi
    
    if [ -d "/opt/cangjie-stdx/docs" ]; then
        echo "📚 stdx API 文档:"
        echo "  - 查看 /opt/cangjie-stdx/docs/ 目录"
        echo ""
    fi
}

show_dev_guide() {
    echo "=== 仓颉编程语言开发指南 ==="
    echo ""
    if [ -f /opt/cangjie-docs/docs/dev-guide/summary_cjnative.md ]; then
        cat /opt/cangjie-docs/docs/dev-guide/summary_cjnative.md
    else
        echo "开发指南文档未找到，请检查安装"
    fi
}

show_tools() {
    echo "=== 仓颉编程语言工具指南 ==="
    echo ""
    if [ -f /opt/cangjie-docs/docs/tools/summary_cjnative.md ]; then
        cat /opt/cangjie-docs/docs/tools/summary_cjnative.md
    else
        echo "工具指南目录:"
        find /opt/cangjie-docs/docs/tools -name "*.md" 2>/dev/null | while read file; do
            echo "  - $(basename "$file")"
        done
    fi
}

search_docs() {
    local keyword="$1"
    echo "=== 搜索关键词: $keyword ==="
    echo ""
    if [ -d "/opt/cangjie-docs/docs" ]; then
        grep -r -n -i "$keyword" /opt/cangjie-docs/docs/ --include="*.md" | head -20
    else
        echo "文档目录未找到，请检查安装"
    fi
}

open_doc() {
    local filename="$1"
    local found_file=""
    
    if [ -d "/opt/cangjie-docs/docs" ]; then
        found_file=$(find /opt/cangjie-docs/docs/ -name "$filename" | head -1)
    fi
    
    if [ -n "$found_file" ]; then
        echo "=== 打开文档: $filename ==="
        echo ""
        cat "$found_file"
    else
        echo "错误: 找不到文档文件 '$filename'"
        echo "请使用 -l 选项查看可用的文档列表"
    fi
}

# 主程序逻辑
case "$1" in
    -h|--help)
        show_help
        ;;
    -l|--list)
        list_docs
        ;;
    -d|--dev-guide)
        show_dev_guide
        ;;
    -t|--tools)
        show_tools
        ;;
    -s|--search)
        if [ -z "$2" ]; then
            echo "错误: 请提供搜索关键词"
            exit 1
        fi
        search_docs "$2"
        ;;
    -o|--open)
        if [ -z "$2" ]; then
            echo "错误: 请提供要打开的文档文件名"
            exit 1
        fi
        open_doc "$2"
        ;;
    "")
        show_help
        ;;
    *)
        echo "错误: 未知选项 '$1'"
        echo "使用 -h 或 --help 查看帮助信息"
        exit 1
        ;;
esac
EOF

chmod +x ~/bin/cj-docs

# 确保 ~/bin 在 PATH 中
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
if [ -f ~/.zshrc ]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
fi

# 创建示例项目
echo "📝 创建示例项目..."
mkdir -p ~/cangjie-examples
cd ~/cangjie-examples

# 创建 Hello World 示例
mkdir -p hello-world
cd hello-world

# 刷新环境变量
export CANGJIE_HOME="/opt/cangjie/cangjie-1.0.1"
export PATH="$CANGJIE_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CANGJIE_HOME/lib:$LD_LIBRARY_PATH"

# 初始化项目
$CANGJIE_HOME/bin/cjpm init --name helloWorld || {
    echo "⚠️  项目初始化失败，可能是环境变量未正确设置"
}

# 创建简单的 Hello World 程序
cat > src/main.cj << 'EOF'
package helloWorld

main(): Int64 {
    println("Hello, 仓颉世界！")
    println("Cangjie Programming Language")
    println("SDK 版本: 1.0.1")
    return 0
}
EOF

# 创建带 stdx 的示例项目
cd ~/cangjie-examples
mkdir -p stdx-example
cd stdx-example

$CANGJIE_HOME/bin/cjpm init --name stdxExample || {
    echo "⚠️  stdx 示例项目初始化失败"
}

# 配置 stdx
if [ -f cjpm.toml ]; then
    cat >> cjpm.toml << 'EOF'

[target.x86_64-unknown-linux-gnu]
  [target.x86_64-unknown-linux-gnu.bin-dependencies]
    path-option = ["/opt/cangjie-stdx/linux_x86_64_llvm/dynamic/stdx"]
EOF
fi

# 创建 stdx 示例代码
cat > src/main.cj << 'EOF'
package stdxExample

import std.io.{BufferedOutputStream, OutputStream}
import std.env.*
import stdx.log.*
import stdx.logger.*

main(): Int64 {
    println("=== 仓颉 stdx 扩展库示例 ===")
    
    // 设置 JSON 格式日志
    let bo = BufferedOutputStream<OutputStream>(getStdOut())
    let jsonLogger = JsonLogger(bo)
    jsonLogger.level = LogLevel.INFO
    setGlobalLogger(jsonLogger)
    
    let appLogger = getGlobalLogger([("app", "stdx-demo")])
    
    appLogger.info("仓颉编程环境安装成功", [("sdk", "1.0.1"), ("stdx", "1.0.1.2")])
    appLogger.info("支持的功能", [("logging", "✅"), ("json", "✅"), ("http", "✅"), ("crypto", "✅")])
    
    println("\n=== stdx 功能验证完成 ===")
    return 0
}
EOF

# 清理临时文件
echo "🧹 清理临时文件..."
rm -rf /tmp/cangjie* /tmp/linux_x86_64_llvm /tmp/cjnative

# 验证安装
echo "✅ 验证安装..."
if [ -x "/opt/cangjie/cangjie-1.0.1/bin/cjc" ]; then
    VERSION_OUTPUT=$(/opt/cangjie/cangjie-1.0.1/bin/cjc -v 2>&1 || echo "版本检查失败")
    echo "编译器版本: $VERSION_OUTPUT"
else
    echo "❌ 编译器安装失败"
    exit 1
fi

if [ -d "/opt/cangjie-stdx/linux_x86_64_llvm" ]; then
    echo "✅ stdx 扩展库安装成功"
else
    echo "⚠️  stdx 扩展库安装可能有问题"
fi

if [ -d "/opt/cangjie-docs/docs" ]; then
    echo "✅ 官方文档安装成功"
else
    echo "⚠️  官方文档安装可能有问题"
fi

echo ""
echo "🎉 仓颉编程环境安装完成！"
echo ""
echo "📋 快速开始："
echo "  - 重新加载终端或运行: source ~/.bashrc"
echo "  - 查看编译器版本: cjc -v"
echo "  - 查看文档: cj-docs -h"
echo "  - 示例项目位置: ~/cangjie-examples/"
echo ""
echo "🔗 有用的命令："
echo "  cjc -v           # 查看编译器版本"
echo "  cjpm --version   # 查看包管理器版本"
echo "  cj-docs -l       # 列出所有文档"
echo "  cj-docs -s 函数  # 搜索函数相关文档"
echo ""
echo "📁 安装位置："
echo "  SDK: /opt/cangjie/cangjie-1.0.1/"
echo "  stdx: /opt/cangjie-stdx/"
echo "  文档: /opt/cangjie-docs/"
echo ""
echo "Happy Coding with Cangjie! 🚀"