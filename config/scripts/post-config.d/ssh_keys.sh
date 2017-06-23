#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# Set ownership and permissions for root user.
sudo -p chown root $SSH_KEYFILE
sudo -p chmod 600 $SSH_KEYFILE

exit 0
