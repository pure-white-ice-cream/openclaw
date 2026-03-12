# 使用 openclaw 官方镜像作为基底
FROM alpine/openclaw:latest

# 设置维护者信息
LABEL maintainer="Manus Agent"
LABEL description="OpenClaw with additional tools (gh, ffmpeg, etc.)"

# 切换到 root 用户进行安装
USER root

# 安装基础工具和新增工具
# gh: GitHub CLI
# ffmpeg: 音视频处理工具
# jq: JSON 处理工具
# curl/wget: 网络工具
# 1. 更新索引 
# 2. 安装基础工具
# 3. 特别注意：github-cli 在 Debian 官方源里可能叫 gh
RUN apt-get update && apt-get install -y \
    ffmpeg \
    jq \
    curl \
    wget \
    bash \
    ca-certificates \
    tzdata \
    gh \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制自定义脚本（如果有）
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# 默认环境变量
ENV TZ=Asia/Shanghai

# 暴露端口（根据 openclaw 原版需求，通常是 8080 或其他）
# EXPOSE 8080

# 启动命令（继承自原版，或根据需要自定义）
# 如果原版有 ENTRYPOINT，这里会自动继承。如果需要额外初始化，可以写一个 entrypoint.sh
