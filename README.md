# OpenClaw Plus

[![Docker Build and Publish](https://github.com/pure-white-ice-cream/openclaw/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/pure-white-ice-cream/openclaw/actions/workflows/docker-publish.yml)

这是一个基于 `alpine/openclaw` 的增强版镜像，集成了常用的开发和多媒体工具，旨在提供更强大的功能支持。

## 🚀 特性

- **基底镜像**: `alpine/openclaw:latest`
- **集成工具**:
  - `gh` (GitHub CLI): 方便在容器内进行 GitHub 操作。
  - `ffmpeg`: 强大的音视频处理工具。
  - `jq`: 轻量级且灵活的命令行 JSON 处理器。
  - `curl` / `wget`: 常用的网络请求工具。
  - `bash`: 提供更友好的 Shell 环境。
- **多架构支持**: `linux/amd64`, `linux/arm64`。
- **自动化构建**: 通过 GitHub Actions 自动构建并推送至 Docker Hub。
- **版本管理**: 支持语义化版本号（SemVer）和 Git SHA 标签。

## 🛠️ 如何添加新工具

为了方便后续维护，添加新工具非常简单：

1. 打开 `Dockerfile`。
2. 在 `RUN apk add --no-cache` 列表中添加你需要的工具包名。
3. 提交代码并推送至 GitHub。
4. GitHub Actions 会自动触发构建并发布新镜像。

## 📦 使用方法

### Docker Run

```bash
docker run -d \
  --name openclaw-plus \
  -e TZ=Asia/Shanghai \
  purewhiteicecream/openclaw:latest
```

### Docker Compose

```yaml
services:
  openclaw:
    image: purewhiteicecream/openclaw:latest
    container_name: openclaw-plus
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

## 🏷️ 标签说明

| 标签 | 说明 |
| :--- | :--- |
| `latest` | 对应 `main` 分支的最新稳定构建 |
| `v*.*.*` | 对应 Git Tag 的语义化版本 |
| `sha-*` | 对应每次提交的短哈希，用于精准回溯 |
| `main` | 对应 `main` 分支的最新代码 |

## 📄 许可证

本项目遵循 [MIT License](LICENSE)。
