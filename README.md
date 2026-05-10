# dev-init

`dev-init` 是一个用于初始化新开发电脑的脚本项目，支持 Windows 和 macOS。

目标是：换新电脑时，不再手动一个个安装 Git、Node、Python、Docker、Codex CLI、Claude Code CLI 等工具，而是维护一份统一配置，然后一键安装。

## 会安装什么

默认工具清单在 `config/tools.json` 里，目前包括：

- Git
- GitHub CLI
- Visual Studio Code
- Docker Desktop
- Node.js LTS
- Python 3.12
- Miniconda
- Codex CLI
- Claude Code CLI

## 本地使用

先 clone 这个仓库，然后根据系统运行对应入口脚本。

Windows PowerShell：

```powershell
cd C:\projects\dev-init
Set-ExecutionPolicy -Scope Process Bypass -Force
.\setup.ps1
```

macOS：

```bash
cd dev-init
bash setup.sh
```

## 新电脑一键初始化

这个项目发布到 GitHub 后，可以直接使用下面的远程初始化命令。

Windows PowerShell：

```powershell
iwr https://raw.githubusercontent.com/RockdaC239/dev-init/main/install.ps1 -UseB | iex
```

macOS：

```bash
curl -fsSL https://raw.githubusercontent.com/RockdaC239/dev-init/main/install.sh | bash
```

这两个安装脚本会先 clone 或更新完整仓库，然后再执行本地的 setup 入口脚本。

## 安装后需要手动登录

有些工具需要浏览器授权或交互登录，脚本不会强制自动登录。安装完成后按需执行：

```bash
gh auth login
codex login
claude login
docker login
```

Docker Desktop 可能需要先手动打开一次，之后终端里的 `docker` 命令才会正常工作。

## 如何调整工具清单

编辑 `config/tools.json`：

- `winget`：Windows 上通过 `winget` 安装的包
- `brew.formulae`：macOS 上通过 Homebrew 安装的命令行工具
- `brew.casks`：macOS 上通过 Homebrew Cask 安装的桌面应用
- `npmGlobal`：通过 `npm install -g` 安装的全局 Node.js CLI
- `postInstall`：安装结束后提示你手动执行的命令

## 项目结构

```text
dev-init/
  config/
    tools.json        # 统一工具清单
  macos/
    setup.sh          # macOS 安装逻辑
  windows/
    setup.ps1         # Windows 安装逻辑
  install.ps1         # Windows 新电脑远程入口
  install.sh          # macOS 新电脑远程入口
  setup.ps1           # Windows 本地入口
  setup.sh            # macOS 本地入口
```

## 设计思路

- 系统工具交给系统包管理器安装：Windows 用 `winget`，macOS 用 Homebrew。
- Node.js 全局命令行工具统一放在 `npmGlobal`。
- 需要交互登录的命令只提示，不在初始化脚本里强制执行。
- Windows 和 macOS 使用同一份 `config/tools.json`，避免两边配置逐渐不一致。
