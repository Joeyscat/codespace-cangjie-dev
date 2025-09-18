#!/usr/bin/env bash

# 备用安装脚本 - 当主安装脚本失败时使用
# 提供最小的仓颉环境设置

set -euo pipefail

echo "🔧 运行备用安装程序..."

# 确保基本目录存在
sudo mkdir -p /opt/cangjie /opt/cangjie-stdx /opt/cangjie-docs
sudo chown -R codespace:codespace /opt/cangjie*

# 基本系统包
echo "📦 安装基本依赖..."
sudo apt-get update -qq >/dev/null 2>&1 || true
sudo apt-get install -y curl wget unzip tar tree jq >/dev/null 2>&1 || true

# 创建文档查看工具（简化版）
echo "📚 创建基础文档工具..."
mkdir -p ~/bin

cat > ~/bin/cj-docs << 'EOF'
#!/bin/bash
echo "仓颉文档查看器 (简化版)"
echo "完整版本需要成功安装后才能使用"
echo ""
echo "建议运行完整安装脚本："
echo "  ./.devcontainer/install-cangjie.sh"
EOF

chmod +x ~/bin/cj-docs

# 添加到 PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc

# 创建基础示例
echo "📝 创建基础示例..."
mkdir -p ~/cangjie-examples/hello-world

cat > ~/cangjie-examples/hello-world/main.cj << 'EOF'
// 仓颉 Hello World 示例
// 需要完整安装仓颉 SDK 后才能编译

package helloWorld

main(): Int64 {
    println("Hello, 仓颉世界！")
    println("请完成仓颉 SDK 安装后重新编译此程序")
    return 0
}
EOF

# 创建安装指导文件
cat > ~/cangjie-examples/INSTALL_GUIDE.md << 'EOF'
# 仓颉环境安装指导

当前为备用模式，请按以下步骤完成完整安装：

## 方法一：重新运行安装脚本
```bash
./.devcontainer/install-cangjie.sh
```

## 方法二：手动安装
1. 下载仓颉 SDK
2. 配置环境变量
3. 安装 stdx 扩展库

## 检查安装状态
```bash
ls -la /opt/cangjie*/
echo $CANGJIE_HOME
```

## 获取帮助
- 查看安装脚本：cat .devcontainer/install-cangjie.sh
- 检查错误日志：查看终端输出
- 参考文档：https://cangjie-lang.cn/
EOF

echo ""
echo "⚠️  备用安装完成"
echo "这只是一个最小环境，请运行完整安装脚本获得完整功能："
echo "  ./.devcontainer/install-cangjie.sh"
echo ""
echo "💡 安装指导文件: ~/cangjie-examples/INSTALL_GUIDE.md"