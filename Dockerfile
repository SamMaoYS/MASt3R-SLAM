# SimpleTuner needs CU141
FROM registry.qunhequnhe.com/mri/layoutlab:0.0.2

# /workspace is the default volume for Runpod & other hosts
WORKDIR /workspace

# Prevents different commands from being stuck by waiting
# on user input during build
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

ADD . /workspace

SHELL ["/bin/bash", "-c"]

RUN source activate layoutlab && pip install -e thirdparty/mast3r && pip install -e thirdparty/in3d && pip install --no-build-isolation -e .
