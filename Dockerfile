# 使用 openclaw 官方镜像作为基底
FROM alpine/openclaw:latest

# 设置维护者信息
LABEL maintainer="pure-white-ice-cream"
LABEL description="OpenClaw with additional tools (gh, ffmpeg, etc.)"

# 2. 从官方镜像直接“借用”二进制文件 (极其稳定，始终对齐官方发布)
# 只要把镜像标签改为 :latest，每次构建都会拉取最新版
COPY --from=ghcr.io/cli/cli:latest /usr/bin/gh /usr/local/bin/gh
COPY --from=mwader/static-ffmpeg:latest /ffmpeg /usr/local/bin/ffmpeg
COPY --from=mwader/static-ffmpeg:latest /ffprobe /usr/local/bin/ffprobe

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
