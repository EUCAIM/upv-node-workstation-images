ARG CUDA_VERSION=""
ARG BASE_VERSION="unknown"
ARG TARGET_VERSION="unknown"

## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG CUDA_VERSION="cuda11"

FROM harbor.chaimeleon-eu.i3m.upv.es/chaimeleon-library-batch/ubuntu_python:${BASE_VERSION}${CUDA_VERSION}

LABEL name="ubuntu_python_tensorflow"
LABEL version="${TARGET_VERSION}$CUDA_VERSION"
LABEL description="Container with ubuntu 22.04, python 3.10.6, ${CUDA_VERSION} and tensorflow."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL authorization="This Dockerfile is intended to build a container image that will be publicly accessible in the CHAIMELEON images repository."

############## Things done by the root user ##############
USER root

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        libsm6 libxrender1 libxext6 libgl1-mesa-glx zlib1g  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Installation of CUDNN extracted from nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
#ENV NV_CUDNN_VERSION=8.7.0.84
#RUN apt-get update && \
#    apt-get install -y --no-install-recommends libcudnn8=8.7.0.84-1+cuda11.8  && \
#    apt-mark hold libcudnn8  && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* 

# Upgrade pip and keyrings to avoid warnings and errors
RUN pip3 install --no-cache-dir --upgrade pip keyrings.alt

############### Now change to normal user ################
USER chaimeleon:chaimeleon
WORKDIR /home/chaimeleon

# Installation of cudnn libraries (required by tensorflow) only in case of the "cuda" version (GPU support)
RUN if [ -n "$CUDA_VERSION" ] ; then pip3 install --no-cache-dir nvidia-cudnn-cu11==8.7.0.84 && \
                                     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chaimeleon/.local/lib/python3.10/site-packages/nvidia/cudnn/lib ; fi
# set the environment variable for the final container environment 
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
# Installation of Tensorflow
RUN pip3 install --no-cache-dir tensorflow==2.12.0


# Verify cudnn (required only for cuda version, for use GPU):
## ls /home/chaimeleon/.local/lib/python3.10/site-packages/nvidia/cudnn/lib/libcudnn.so.8

# Verify tensorflow: https://www.tensorflow.org/install/pip?hl=es-419#step-by-step_instructions
## import tensorflow as tf
## print(tf.reduce_sum(tf.random.normal([1000, 1000])))
## print(tf.config.list_physical_devices('GPU'))

