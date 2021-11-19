FROM chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu:2.0

LABEL name="ubuntu_python_tensorflow_gpu_desktop_vnc"
LABEL description="Container with ubuntu 18.04 (bionic) distribution with gpu (cuda 10.1), tensorflow 2.3.1, lxde desktop and vnc service."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="2.0"

USER root
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc \
        vim-tiny wget less firefox ttf-ubuntu-font-family ttf-wqy-zenhei  \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    
# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

COPY rootfs /
RUN chown -R chaimeleon:chaimeleon /home/chaimeleon \
    && chmod +x /startup.sh \
    && chmod +x /usr/local/bin/xvfb.sh

ADD createGuacamoleConnection.py /bin/createGuacamoleConnection.py

#EXPOSE 80
EXPOSE 5900
USER chaimeleon:chaimeleon
WORKDIR /home/chaimeleon

ENV SUPERVISOR_CONF_FILE=/home/chaimeleon/.supervisor/conf.d/supervisord.conf
RUN mkdir -p /home/chaimeleon/.supervisor/conf.d/ \
    && cp /etc/supervisor/conf.d/supervisord.conf $SUPERVISOR_CONF_FILE

# default values to environment variables which can be configured
ENV VNC_PASSWORD= \
    PASSWORD= \
    X11VNC_ARGS= \
    OPENBOX_ARGS= \
    RESOLUTION= \
    GUACAMOLE_URL= \
    GUACAMOLE_USER= \
    GUACAMOLE_PASSWORD= \
    GUACD_HOST= \
    GUACAMOLE_CONNECTION_NAME=
    
#HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]

