FROM chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc:1.2

LABEL name="ubuntu_python_tensorflow_gpu_desktop_vnc_sshd"
LABEL description="Container with ubuntu 18.04 (bionic) distribution with gpu (cuda 10.1), tensorflow 2.3.1, lxde desktop, vnc service and ssh service."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="1.2"

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends git openssh-server rsync augeas-tools rssh \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    
# && apt install -y --no-install-recommends git openssh rsync augeas shadow rssh \
    
RUN mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache

#   deluser $(getent passwd 33 | cut -d: -f1) && \
#   delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    

EXPOSE 22

#EXPOSE 80
#EXPOSE 5900

# ENTRYPOINT ["/startup.sh"]
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]

#CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]


# WORKDIR /root
# ENV HOME=/home/ubuntu \
#     SHELL=/bin/bash
# HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health


