#!/usr/bin/env bash

jupyter notebook --generate-config

echo "
[program:jupyter]
priority=25
command=jupyter notebook --debug --ip='*' --notebook-dir=/home/chaimeleon --no-browser --NotebookApp.token='' --NotebookApp.password=''
" >> $SUPERVISOR_CONF_FILE

# Run the init script of the base image
source /home/chaimeleon/.init/startup.sh
