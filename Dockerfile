# 第一阶段：基础镜像（包含系统依赖）
FROM python:3.11-slim as base

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 确保 /etc/apt/sources.list 存在，并使用清华大学镜像源更新它
RUN if [ ! -f "/etc/apt/sources.list" ]; then echo "deb http://deb.debian.org/debian bookworm main contrib non-free" > /etc/apt/sources.list; fi && \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free" >> /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgl1 \
    libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 uv 包管理器
RUN pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --no-cache-dir uv

# 第二阶段：应用镜像（基于基础镜像，添加应用代码和依赖）
FROM base as app

# 复制依赖文件
COPY requirements.txt .

# 安装 Python 依赖
RUN uv pip install --system -r requirements.txt --index https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# 复制项目文件
COPY . .

# 创建必要的目录
RUN mkdir -p /app/logs /app/temp

# 暴露端口
EXPOSE 8000

# 启动命令（默认启动 API 服务）
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]