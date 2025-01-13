# ベースイメージとしてARM用のUbuntu 20.04を使用
FROM arm64v8/ubuntu:20.04

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    vim \
    wget \
    ca-certificates \
    strace \
    sysstat  \
    binutils \
    psmisc \
    python3 \
    python3-pip \
    fonts-noto-cjk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/takao-fonts.tar.gz https://ja.osdn.net/dl/takao/takao-fonts/takao-fonts-003.02.tar.gz \
    && mkdir -p /usr/share/fonts/truetype/takao \
    && tar -xzf /tmp/takao-fonts.tar.gz -C /usr/share/fonts/truetype/takao \
    && fc-cache -fv \
    && rm /tmp/takao-fonts.tar.gz

# 必要なPython パッケージをインストール
COPY requirements.txt /workspace/requirements.txt
RUN pip3 install -r /workspace/requirements.txt

# Goの最新バージョンをインストール
ENV GO_VERSION=1.21.1
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-arm64.tar.gz && \
    rm go${GO_VERSION}.linux-arm64.tar.gz

# 環境変数の設定
ENV PATH="/usr/local/go/bin:${PATH}"

# 作業ディレクトリを設定
WORKDIR /workspace

# コンテナ起動時に実行されるコマンド
CMD ["/bin/bash"]
