#!/usr/bin/env bash


#if [ -n "$DATASET_REFERENCES_FILE" ]; then
#   python /root/downloadEForms.py --input $PERSISTENT_HOME_MOUNT_POINT/PRIMAGE_HOME/$HOME_DIR_NAME/$DATASET_REFERENCES_FILE --qp-host $QUIBIM_HOST \
#                                  --user $QUIBIM_USER --password $QUIBIM_PASSWORD \
#                                  --output-dir /dataset --qp-working-dir /mnt/oneclient/PRIMAGE_DATALAKE
#fi

echo "$@" >.runcmd
source .runcmd
