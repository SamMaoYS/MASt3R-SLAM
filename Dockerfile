# SimpleTuner needs CU141
FROM registry.qunhequnhe.com/mri/pytorch:2.4.1-cuda12.4-cudnn9-devel

# /workspace is the default volume for Runpod & other hosts
WORKDIR /workspace

# Prevents different commands from being stuck by waiting
# on user input during build
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

# Install misc unix libraries
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && apt-get update -y && apt-get install -y python3 python3-pip && apt-get install -y python3.10-venv && apt-get install -y --no-install-recommends openssh-server \
    openssh-client \
    git-all \
    git-lfs \
    wget \
    curl \
    tmux \
    tldr \
    nvtop \
    vim \
    rsync \
    net-tools \
    less \
    iputils-ping \
    7zip \
    zip \
    unzip \
    htop \
    libgl1-mesa-glx \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-dev libglew-dev pkg-config libegl1-mesa-dev libwayland-dev libxkbcommon-dev wayland-protocols \
    inotify-tools psmisc && rm -rf /var/lib/apt/lists/*

# Set up git to support LFS, and to store credentials; useful for Huggingface Hub
RUN git config --global credential.helper store && \
    git lfs install

ADD . /workspace

SHELL ["/bin/bash", "-c"]

ENV HTTP_PROXY="http://pac.qunhequnhe.com:8080"
ENV HTTPS_PROXY="http://pac.qunhequnhe.com:8080"

RUN conda create -y -n mast3r-slam python=3.11 && source activate mast3r-slam && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && conda install -y cmake && conda install -y conda-forge::ninja && conda install -y nvidia/label/cuda-12.4.0::cuda-toolkit && conda install -y pytorch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 pytorch-cuda=12.4 -c pytorch -c nvidia && pip install -e thirdparty/mast3r && pip install -e thirdparty/in3d && pip install --no-build-isolation -e .
