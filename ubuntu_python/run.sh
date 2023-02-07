#!/usr/bin/env bash

if curl --connect-timeout 4 pypi.org; then
    # if there is connection to Internet, upgrade pip and keyrings.alt to avoid warnings
    pip3 install --upgrade pip
    pip3 install --upgrade keyrings.alt
fi

echo "$@" >.runcmd
source .runcmd
