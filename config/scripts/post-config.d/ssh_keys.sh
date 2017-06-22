#!/bin/bash
# Set ownership and permissions for ubnt user
source /config/user-data/edgerouter-backup.conf

sudo chown root $SSH_KEYFILE
sudo chmod 600 $SSH_KEYFILE

exit 0
