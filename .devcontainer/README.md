# 仓颉编程环境 Codespace 配置

这个配置文件可以在 GitHub Codespaces 中自动安装完整的仓颉编程环境。

## 🚀 快速开始

### 方法一：使用 GitHub Codespaces

1. 点击仓库页面的 "Code" 按钮
2. 选择 "Codespaces" 标签
3. 点击 "Create codespace on main"
4. 等待环境自动安装（大约 3-5 分钟）

### 方法二：手动运行安装脚本

如果您已经在 Codespace 中，可以手动运行安装脚本：

```bash
./.devcontainer/install-cangjie.sh
```

## 📦 自动安装内容

- **仓颉 SDK 1.0.1** - 编译器、包管理器和开发工具
- **stdx 扩展库 1.0.1.2** - 网络、加密、日志等高级功能
- **官方开发文档** - 完整的语言指南和 API 文档
- **示例项目** - Hello World 和 stdx 功能演示
- **文档查看工具** - 便捷的 `cj-docs` 命令

## 🔧 环境配置

### 环境变量
```bash
export CANGJIE_HOME="/opt/cangjie/cangjie-1.0.1"
export PATH="$CANGJIE_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CANGJIE_HOME/lib:$LD_LIBRARY_PATH"
```

### 便捷别名
```bash
alias cj='cjc'        # 编译器
alias cjp='cjpm'      # 包管理器
alias cjf='cjfmt'     # 格式化工具
alias cjd='cjdb'      # 调试器
```

## 📚 使用指南

### 基本命令

```bash
# 查看版本
cjc -v
cjpm --version

# 查看文档
cj-docs -h          # 帮助
cj-docs -l          # 列出所有文档
cj-docs -d          # 开发指南
cj-docs -s "函数"   # 搜索内容
```

### 创建新项目

```bash
# 创建项目目录
mkdir my-cangjie-app
cd my-cangjie-app

# 初始化项目
cjpm init --name myApp

# 编辑 src/main.cj
# 编译和运行
cjpm build
cjpm run
```

### 使用 stdx 扩展库

在 `cjpm.toml` 中添加：

```toml
[target.x86_64-unknown-linux-gnu]
  [target.x86_64-unknown-linux-gnu.bin-dependencies]
    path-option = ["/opt/cangjie-stdx/linux_x86_64_llvm/dynamic/stdx"]
```

在代码中导入：

```cangjie
import stdx.log.*
import stdx.logger.*
import stdx.net.http.*
import stdx.encoding.json.*
```

## 📁 目录结构

```
/opt/
├── cangjie/
│   └── cangjie-1.0.1/          # 仓颉 SDK
├── cangjie-stdx/               # stdx 扩展库
│   ├── linux_x86_64_llvm/
│   └── docs/
└── cangjie-docs/               # 官方文档
    └── docs/

~/cangjie-examples/             # 示例项目
├── hello-world/                # Hello World 示例
└── stdx-example/               # stdx 功能示例
```

## 🎯 示例项目

安装完成后，您可以在 `~/cangjie-examples/` 找到两个示例项目：

### Hello World 示例
```bash
cd ~/cangjie-examples/hello-world
cjpm build
cjpm run
```

### stdx 功能示例
```bash
cd ~/cangjie-examples/stdx-example
cjpm build
cjpm run
```

## 🔧 VS Code 扩展

配置文件会自动安装以下 VS Code 扩展：

- Markdown 支持
- 十六进制编辑器
- 拼写检查器

## 🌐 端口转发

自动配置以下端口转发：

- **8080** - 仓颉 HTTP 服务器
- **3000** - 开发服务器
- **8000** - 备用端口
- **9000** - 备用端口

## 🔍 故障排除

### 安装失败

如果自动安装失败，您可以：

1. 检查网络连接
2. 手动运行安装脚本：
   ```bash
   ./.devcontainer/install-cangjie.sh
   ```
3. 查看安装日志

### 环境变量未生效

重新加载环境变量：
```bash
source ~/.bashrc
# 或者
source ~/.zshrc
```

### 编译错误

确保项目配置正确：
```bash
# 检查编译器
cjc -v

# 检查项目配置
cat cjpm.toml
```

## 📋 配置文件说明

### `.devcontainer/devcontainer.json`
- 定义 Codespace 容器配置
- 指定基础镜像和功能
- 配置 VS Code 扩展和设置
- 设置端口转发

### `.devcontainer/install-cangjie.sh`
- 自动安装脚本
- 下载并安装仓颉 SDK
- 配置 stdx 扩展库
- 安装文档和工具
- 创建示例项目

## 🤝 贡献

如果您发现任何问题或有改进建议，欢迎：

1. 提交 Issue
2. 创建 Pull Request
3. 分享使用经验

## 📄 许可证

此配置文件遵循 MIT 许可证。

---

Happy Coding with Cangjie! 🎉