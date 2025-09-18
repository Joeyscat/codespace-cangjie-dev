# 仓颉编程语言博客项目

这是一个关于仓颉编程语言的博客项目，包含完整的开发环境配置和示例代码。

## 🚀 快速开始

### 使用 GitHub Codespaces（推荐）

1. 点击 "Code" 按钮 → "Codespaces" → "Create codespace on main"
2. 等待自动安装仓颉编程环境（约 3-5 分钟）
3. 安装完成后即可开始开发

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Joeyscat/codespace-cangjie-dev)

### 手动安装

如果您想在本地环境安装，请参考：

```bash
# 克隆仓库
git clone https://github.com/Joeyscat/codespace-cangjie-dev.git
cd codespace-cangjie-dev

# 运行安装脚本
./.devcontainer/install-cangjie.sh
```

## 📦 包含内容

- **仓颉 SDK 1.0.1** - 完整的编译器和开发工具链
- **stdx 扩展库 1.0.1.2** - 网络、加密、日志等高级功能
- **官方开发文档** - 语言指南和 API 参考
- **示例代码** - Hello World 和 stdx 功能演示
- **开发工具** - 文档查看器、环境配置等

## 📚 项目结构

```
📁 项目根目录
├── 📁 .devcontainer/          # Codespace 配置
│   ├── 📄 devcontainer.json   # 容器配置
│   ├── 📄 install-cangjie.sh  # 自动安装脚本
│   └── 📄 README.md           # 配置说明
├── 📁 .github/workflows/      # GitHub Actions
├── 📁 docs/                   # 项目文档
└── 📁 scripts/                # 实用脚本
```

## 🛠️ 开发工具

### 基本命令

```bash
cjc -v                 # 查看编译器版本
cjpm --version         # 查看包管理器版本
cj-docs -h            # 查看文档工具帮助
```

### 创建新项目

```bash
mkdir my-cangjie-app
cd my-cangjie-app
cjpm init --name myApp
```

### 使用 stdx 扩展库

在 `cjpm.toml` 中配置：

```toml
[target.x86_64-unknown-linux-gnu]
  [target.x86_64-unknown-linux-gnu.bin-dependencies]
    path-option = ["/opt/cangjie-stdx/linux_x86_64_llvm/dynamic/stdx"]
```

## 📖 文档和资源

- [仓颉官方网站](https://cangjie-lang.cn/)
- [stdx 扩展库文档](https://gitcode.com/Cangjie/cangjie_stdx)
- [官方开发文档](https://gitcode.com/Cangjie/cangjie_docs)
- [安装配置指南](docs/cangjie-installation-guide.md)
- [Codespace 使用说明](.devcontainer/README.md)

## 🎯 示例项目

安装完成后，可以在 `~/cangjie-examples/` 找到示例项目：

- **hello-world** - 基础 Hello World 程序
- **stdx-example** - stdx 功能演示

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

## 📄 许可证

MIT License

---

Happy Coding with Cangjie! 🎉