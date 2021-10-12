#!/usr/bin/env bash

if [ -z "$VNC_PASSWORD" ]; then
    export VNC_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;)
    echo "VNC password random generated: $VNC_PASSWORD"
fi
echo -n "$VNC_PASSWORD" > /.password1
x11vnc -storepasswd $(cat /.password1) /.password2
chmod 400 /.password*
sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf

if [ -n "$X11VNC_ARGS" ]; then
    sed -i "s/^command=x11vnc.*/& ${X11VNC_ARGS}/" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$OPENBOX_ARGS" ]; then
    sed -i "s#^command=/usr/bin/openbox\$#& ${OPENBOX_ARGS}#" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$RESOLUTION" ]; then
    sed -i "s/1024x768/$RESOLUTION/" /usr/local/bin/xvfb.sh
fi

USER=${USER:-root}
HOME=/root
if [ "$USER" != "root" ]; then
    echo "* enable custom user: $USER"
    useradd --create-home --shell /bin/bash --user-group --groups adm,sudo $USER
    if [ -z "$PASSWORD" ]; then
        echo "  set default password to \"ubuntu\""
        PASSWORD=ubuntu
    fi
    HOME=/home/$USER
    echo "$USER:$PASSWORD" | chpasswd
    cp -r /root/{.config,.gtkrc-2.0,.asoundrc} ${HOME}
    chown -R $USER:$USER ${HOME}
    [ -d "/dev/snd" ] && chgrp -R adm /dev/snd
fi
sed -i -e "s|%USER%|$USER|" -e "s|%HOME%|$HOME|" /etc/supervisor/conf.d/supervisord.conf

# home folder
if [ ! -x "$HOME/.config/pcmanfm/LXDE/" ]; then
    mkdir -p $HOME/.config/pcmanfm/LXDE/
    ln -sf /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/
    chown -R $USER:$USER $HOME
fi

source /root/run.sh

# create usefull links in HOME
if [ -n "$PERSISTENT_HOME_MOUNT_POINT" ]; then
    ln -s $PERSISTENT_HOME_MOUNT_POINT $HOME/persistent-home
fi
if [ -n "$DATASET_MOUNT_POINT" ]; then
    ln -s $DATASET_MOUNT_POINT $HOME/dataset
fi

if [ -n "$GUACAMOLE_USER" ]; then
    python /root/createGuacamoleConnection.py --url $GUACAMOLE_URL --user $GUACAMOLE_USER --password $GUACAMOLE_PASSWORD \
                                              --oidc-url $OIDC_URL --oidc-client-id $OIDC_GUACAMOLE_CLIENT_ID \
                                              --guacd-host $GUACD_HOST --vnc-password $VNC_PASSWORD \
                                              --sftp-user $USER --sftp-password $PASSWORD \
                                              --debug --connection-name $(date +%Y-%m-%d-%H-%M-%S)--$HOSTNAME
fi

# clean up
export VNC_PASSWORD=
PASSWORD=

exec /bin/tini -- supervisord -n -c /etc/supervisor/supervisord.conf
