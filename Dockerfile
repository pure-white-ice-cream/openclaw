# 使用 openclaw 官方镜像作为基底
FROM alpine/openclaw:latest

# 设置维护者信息
LABEL maintainer="Manus Agent"
LABEL description="OpenClaw with additional tools (gh, ffmpeg, etc.)"

# 切换到 root 用户进行安装
USER root

# 直接下载官方二进制包
RUN export ARCH=$(dpkg --print-architecture) && \
    curl -sSL "https://github.com/cli/cli/releases/download/v2.45.0/gh_2.45.0_linux_${ARCH}.tar.gz" | \
    tar xz --strip-components=2 -C /usr/local/bin/ "gh_2.45.0_linux_${ARCH}/bin/gh" && \
    chmod +x /usr/local/bin/gh

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
