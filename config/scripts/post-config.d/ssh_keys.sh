#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# This script runs at boot of the EdgeRouter

# Set ownership and permissions for root user so that ssh/scp don't complain.
sudo chown root $SSH_KEYFILE
sudo chmod 600 $SSH_KEYFILE

exit 0