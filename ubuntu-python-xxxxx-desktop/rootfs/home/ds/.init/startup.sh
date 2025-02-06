#!/usr/bin/env bash

/home/ds/.init/configure_sshd.sh

USER=ds
PREVIOUS_PASSWORD=password
HOME=/home/$USER

if [ -z "$VNC_PASSWORD" ]; then
    export VNC_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;)
    echo "VNC password random generated: $VNC_PASSWORD"
fi
echo -n "$VNC_PASSWORD" > $HOME/.password1
x11vnc -storepasswd $(cat $HOME/.password1) $HOME/.password2
chmod 400 $HOME/.password*
sed -i "s#^command=x11vnc.*#& -rfbauth $HOME/.password2#" $SUPERVISOR_CONF_FILE

if [ -n "$X11VNC_ARGS" ]; then
    sed -i "s/^command=x11vnc.*/& ${X11VNC_ARGS}/" $SUPERVISOR_CONF_FILE
fi

if [ -n "$OPENBOX_ARGS" ]; then
    sed -i "s#^command=/usr/bin/openbox\$#& ${OPENBOX_ARGS}#" $SUPERVISOR_CONF_FILE
fi

if [ -n "$RESOLUTION" ]; then
    sed -i "s/1280x800/$RESOLUTION/" /usr/local/bin/xvfb.sh
fi

if [ -z "$PASSWORD" ]; then
    export PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;)
    echo "$USER password random generated: $PASSWORD"
fi
echo "Changing password for the user $USER"
#echo "$USER:$PASSWORD" | chpasswd
if [ $(whoami) == 'root' ]; then 
    echo -e "$PASSWORD\n$PASSWORD" | (passwd $USER)
    # add the user to the group "sudo"
    usermod -aG sudo $USER
else
    echo -e "$PREVIOUS_PASSWORD\n$PASSWORD\n$PASSWORD" | (passwd $USER)
fi

#[ -d "/dev/snd" ] && chgrp -R adm /dev/snd

sed -i -e "s|%USER%|$USER|" -e "s|%HOME%|$HOME|" $SUPERVISOR_CONF_FILE

# home folder
if [ ! -x "$HOME/.config/pcmanfm/LXDE/" ]; then
    mkdir -p $HOME/.config/pcmanfm/LXDE/
    ln -sf /usr/local/share/wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/
fi

# Run the init script of the base image
source $HOME/.init/run.sh

if [ -f $HOME/persistent-shared-folder/apps/jobman/jobman.tar.gz ]; then
    $HOME/.local/bin/install-jobman
fi

# clean up
export VNC_PASSWORD=
PASSWORD=

echo Running supervisor...
#exec /bin/tini -- supervisord -n -c /etc/supervisor/supervisord.conf
export TINI_SUBREAPER=
# we change working directory to write there the supervisor log and pid file
cd $HOME/.supervisor
exec /bin/tini -- supervisord -n -c $SUPERVISOR_CONF_FILE
