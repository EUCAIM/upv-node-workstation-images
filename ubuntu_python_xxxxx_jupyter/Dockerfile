ARG CUDA_VERSION
ARG AI_TOOL=tensorflow
## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG CUDA_VERSION="cuda10"
## Uncomment or include in "docker build --build-arg" for building with pyTorch
#ARG AI_TOOL=pytorch

FROM chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_${AI_TOOL}:2.2$CUDA_VERSION

LABEL name="ubuntu_python_${AI_TOOL}_jupyter"
LABEL version="1.2$CUDA_VERSION"
LABEL description="Container with ubuntu 18.04 (bionic), $AI_TOOL and jupyter notebooks web service."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"

USER root
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends \
                   curl wget less run-one \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    
# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

RUN pip install jupyter

COPY --chown=chaimeleon:chaimeleon rootfs/home/chaimeleon /home/chaimeleon/
#RUN chown -R chaimeleon:chaimeleon /home/chaimeleon \
RUN chmod +x /home/chaimeleon/.init/startup.sh

#ADD createGuacamoleConnection.py /bin/createGuacamoleConnection.py

EXPOSE 8888
USER chaimeleon:chaimeleon
WORKDIR /home/chaimeleon

# default values to environment variables which can be configured
ENV PASSWORD= \
    URL_PATH=
    
#HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
#ENTRYPOINT ["/home/chaimeleon/.init/startup.sh"]

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/home/chaimeleon/.init/startup.sh"]
