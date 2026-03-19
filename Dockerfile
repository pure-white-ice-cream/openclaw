# 使用 openclaw 官方镜像作为基底
FROM alpine/openclaw:2026.3.13-1

# 设置维护者信息
LABEL maintainer="pure-white-ice-cream"
LABEL description="OpenClaw with additional tools (gh, ffmpeg, clawhub, etc.)"

# 切换到 root 用户进行安装
USER root

# 1. 安装必要的解压工具 (假设 openclaw 内部至少有 curl)
# 如果连 curl 都没有，我们会使用更通用的方式
RUN (type curl >/dev/null 2>&1 || (apk add --no-cache curl || apt-get update && apt-get install -y curl || yum install -y curl))

# 2. 安装工具
RUN set -e; \
    # 自动识别架构: x86_64 -> amd64, aarch64 -> arm64
    ARCH=$(uname -m); \
    if [ "$ARCH" = "x86_64" ]; then \
        GH_ARCH="amd64"; FF_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        GH_ARCH="arm64"; FF_ARCH="arm64"; \
    fi; \
    \
    # 下载并安装 gh (GitHub CLI) - 自动获取最新版本
    GH_LATEST=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'); \
    curl -sSL "https://github.com/cli/cli/releases/download/v${GH_LATEST}/gh_${GH_LATEST}_linux_${GH_ARCH}.tar.gz" | \
    tar xz --strip-components=2 -C /usr/local/bin/ "gh_${GH_LATEST}_linux_${GH_ARCH}/bin/gh"; \
    \
    # 下载并安装 ffmpeg (静态编译版)
    # 注意：johnvansickle 的 arm64 路径稍有不同，这里做了兼容处理
    if [ "$GH_ARCH" = "amd64" ]; then \
        FF_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"; \
    else \
        FF_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz"; \
    fi; \
    curl -sSL "$FF_URL" | tar xJ -C /usr/local/bin/ --strip-components=1 --wildcards "*/ffmpeg" "*/ffprobe"; \
    \
    # 安装 clawhub
    # 使用 npm 全局安装，并清除缓存以减小体积
    npm install -g clawhub && npm cache clean --force; \
    \
    # 赋予权限
    chmod +x /usr/local/bin/gh /usr/local/bin/ffmpeg /usr/local/bin/ffprobe

# 设置工作目录
# WORKDIR /app

# 复制自定义脚本（如果有）
# COPY scripts/ /usr/local/bin/
# RUN chmod +x /usr/local/bin/*

# 默认环境变量
# ENV TZ=Asia/Shanghai

# 暴露端口（根据 openclaw 原版需求，通常是 18789 或其他）
# EXPOSE 18789

# 启动命令（继承自原版，或根据需要自定义）
# 如果原版有 ENTRYPOINT，这里会自动继承。如果需要额外初始化，可以写一个 entrypoint.sh
