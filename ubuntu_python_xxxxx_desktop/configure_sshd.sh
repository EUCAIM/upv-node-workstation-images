#!/usr/bin/env bash

set -e
[ "$DEBUG" == 'true' ] && set -x

echo "> Starting SSHD"

## Update MOTD
#if [ -v MOTD ]; then
#    echo "Updating motd..."
#    echo -e "$MOTD" > /etc/motd
#fi

#https://www.golinuxcloud.com/run-sshd-as-non-root-user-without-sudo/
mkdir -p /home/chaimeleon/.custom_ssh
SSHD_CONFIG_FILE=/home/chaimeleon/.custom_ssh/sshd_config
ALGORITHMS="rsa ecdsa ed25519"

echo "
Port 2222
AuthorizedKeysFile  .ssh/authorized_keys
ChallengeResponseAuthentication no
UsePAM yes
PidFile /home/chaimeleon/.custom_ssh/sshd.pid
AcceptEnv LANG LC_*
# UsePrivilegeSeparation no
HostKeyAlgorithms rsa-sha2-512,rsa-sha2-256,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,ssh-rsa,ssh-dss
" > $SSHD_CONFIG_FILE

create_hostkeys() {
    local BASE_DIR=${1:-'/etc/ssh'}
    echo ">>> Generating hostkeys in ${BASE_DIR}"
    for item in $ALGORITHMS; do
        ssh-keygen -f ${BASE_DIR}/ssh_host_${item}_key -N '' -t ${item} -q
    done
}

print_hostkeys_fingerprints() {
    local BASE_DIR=${1:-'/etc/ssh'}
    for item in $ALGORITHMS; do
        echo ">>> Fingerprints for ${item} host key"
        ssh-keygen -E md5 -lf ${BASE_DIR}/ssh_host_${item}_key
        ssh-keygen -E sha256 -lf ${BASE_DIR}/ssh_host_${item}_key
        ssh-keygen -E sha512 -lf ${BASE_DIR}/ssh_host_${item}_key        
    done
}

set_hostkeys() {
    local BASE_DIR=${1:-'/etc/ssh'}
    for item in $ALGORITHMS; do
        echo "HostKey ${BASE_DIR}/ssh_host_${item}_key" >> $SSHD_CONFIG_FILE
    done
}

create_hostkeys /home/chaimeleon/.custom_ssh
print_hostkeys_fingerprints /home/chaimeleon/.custom_ssh
set_hostkeys /home/chaimeleon/.custom_ssh 

# PasswordAuthentication (disabled by default)
if [[ "${SSH_ENABLE_PASSWORD_AUTH}" == "true" ]]; then
    echo "PasswordAuthentication yes" >> $SSHD_CONFIG_FILE
    echo "WARNING: password authentication enabled."
else
    echo "PasswordAuthentication no" >> $SSHD_CONFIG_FILE
    echo "INFO: password authentication is disabled by default. Set SSH_ENABLE_PASSWORD_AUTH=true to enable."
fi

# Enable AllowTcpForwarding
if [[ "${TCP_FORWARDING}" == "true" ]]; then
    echo "AllowTcpForwarding yes" >> $SSHD_CONFIG_FILE
fi
# Enable GatewayPorts
if [[ "${GATEWAY_PORTS}" == "true" ]]; then
    echo "GatewayPorts yes" >> $SSHD_CONFIG_FILE
fi
# Disable SFTP
if [[ "${DISABLE_SFTP}" == "true" ]]; then
    echo "SFTP not enabled."
else
    echo "Subsystem   sftp    /usr/lib/openssh/sftp-server" >> $SSHD_CONFIG_FILE
fi

echo "
[program:sshd]
priority=25
command=/usr/sbin/sshd -D -e -f $SSHD_CONFIG_FILE -E /home/chaimeleon/.custom_ssh/sshd.log
" >> $SUPERVISOR_CONF_FILE

#command=/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
## To debug the execution of sshd: 
#/usr/sbin/sshd -D -d -e -f $SSHD_CONFIG_FILE

