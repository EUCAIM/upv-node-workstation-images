#!/usr/bin/env bash

if curl --connect-timeout 4 pypi.org 2> /dev/null; then
    # if there is connection to Internet, upgrade pip and keyrings.alt to avoid warnings
    pip3 install --upgrade pip > /dev/null 2>&1
    pip3 install --upgrade keyrings.alt > /dev/null 2>&1
fi

# The usual path for binaries of apps installed by the user
export PATH=$PATH:/home/ds/.local/bin

if [ -f /home/ds/persistent-shared-folder/apps/upload-result/upload-result ]; then
    /home/ds/.local/bin/install-upload-result > /dev/null 2>&1
fi

# Execute the user custom init script if exists
if [ -f /home/ds/persistent-home/init.sh ]; then
    echo "### Executing the user custom init script ###"
    bash /home/ds/persistent-home/init.sh
    echo "### End of user custom init script ###"
fi

echo "$@" >.runcmd
source .runcmd
