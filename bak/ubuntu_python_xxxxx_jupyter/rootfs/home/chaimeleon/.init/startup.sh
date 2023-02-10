#!/usr/bin/env bash

USER=chaimeleon
PREVIOUS_PASSWORD=chaimeleon
# HOME=/home/$USER

if [ -z "$PASSWORD" ]; then
    export PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;)
    echo "$USER password random generated: $PASSWORD"
fi
echo "Changing password for the user $USER"
#echo "$USER:$PASSWORD" | chpasswd
echo -e "$PREVIOUS_PASSWORD\n$PASSWORD\n$PASSWORD" | (passwd $USER)

source /home/chaimeleon/.init/run.sh

jupyter notebook --generate-config
#echo "
#c.NotebookApp.password=u'sha1:bd3bb32d0e87:c69c07a92f3547a89db16b08eb2b987650d42853'
#" >> /home/chaimeleon/.jupyter/jupyter_notebook_config.py
if [ -n "$URL_PATH" ]; then
    echo "
c.NotebookApp.base_url = '/$URL_PATH/'
" >> /home/chaimeleon/.jupyter/jupyter_notebook_config.py
fi

run-one-constantly jupyter notebook --debug --ip='*' --notebook-dir=/home/chaimeleon --NotebookApp.token=$PASSWORD --no-browser

# clean up
PASSWORD=
