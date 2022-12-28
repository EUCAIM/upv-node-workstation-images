ARG CUDA_VERSION=""
ARG BASE_VERSION="unknown"
ARG TARGET_VERSION="unknown"

## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG CUDA_VERSION="cuda10"

FROM harbor.chaimeleon-eu.i3m.upv.es/chaimeleon-library/ubuntu_python:${BASE_VERSION}${CUDA_VERSION}
# FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime   We can build from a container with pytorch already installed (untested alternative)
# FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-runtime   Cuda major version in container must match with the version installed in the host

LABEL name="ubuntu_python_pytorch"
LABEL version="${TARGET_VERSION}$CUDA_VERSION"
LABEL description="Container with ubuntu 18.04 (bionic), ${CUDA_VERSION} and pyTorch 1.10."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"

USER root

RUN apt-get -y update && \
    apt-get -y install libgl1-mesa-glx && \
    apt-get clean

USER chaimeleon:chaimeleon
WORKDIR /home/chaimeleon

#RUN pip3 install --no-cache-dir torch==1.6.0+cu101 torchvision==0.7.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html   # for CUDA 10.1, includes CUDNN 1.7
#RUN pip3 install --no-cache-dir torch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0   # for CUDA 10.2, includes CUDNN 1.7
RUN pip3 install --no-cache-dir torch==1.10.0 torchvision==0.11.1 torchaudio==0.10.0    # for CUDA 10.2, includes CUDNN 1.8

# Verify pyTorch: https://pytorch.org/get-started/locally/#linux-verification
## import torch
## x = torch.rand(5, 3)
## print(x)
## torch.cuda.is_available()
