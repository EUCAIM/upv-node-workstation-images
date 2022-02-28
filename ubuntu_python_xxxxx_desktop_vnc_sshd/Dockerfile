ARG CUDA_VERSION
ARG AI_TOOL=tensorflow
## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG CUDA_VERSION="cuda10"
## Uncomment or include in "docker build --build-arg" for building with pyTorch
#ARG AI_TOOL=pytorch

FROM chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_${AI_TOOL}_desktop_vnc:2.3$CUDA_VERSION

LABEL name="ubuntu_python_${AI_TOOL}_desktop_vnc_sshd"
LABEL description="Container with ubuntu 18.04 (bionic), ${AI_TOOL}, lxde desktop, vnc service and ssh service."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="2.4$CUDA_VERSION"

USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends git openssh-server \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
        
COPY entry.sh /home/chaimeleon/.init/entry.sh
RUN chmod +x /home/chaimeleon/.init/entry.sh

EXPOSE 2222

USER chaimeleon:chaimeleon
WORKDIR /home/chaimeleon

# default values to environment variables which can be configured
ENV SSH_ENABLE_PASSWORD_AUTH= \
    TCP_FORWARDING= \
    GATEWAY_PORTS= \
    DISABLE_SFTP=

# HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/home/chaimeleon/.init/entry.sh"]

