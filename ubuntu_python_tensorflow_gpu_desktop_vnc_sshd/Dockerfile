FROM chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc:2.0

LABEL name="ubuntu_python_tensorflow_gpu_desktop_vnc_sshd"
LABEL description="Container with ubuntu 18.04 (bionic) distribution with gpu (cuda 10.1), tensorflow 2.3.1, lxde desktop, vnc service and ssh service."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="2.1"

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

# ENTRYPOINT ["/startup.sh"]
ENTRYPOINT ["/home/chaimeleon/.init/entry.sh"]

#CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]

# HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health


