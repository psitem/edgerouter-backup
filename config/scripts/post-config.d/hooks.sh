#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# Fix ownership
sudo chown -R root:vyattacfg /config/userdata
sudo chown -R root:vyattacfg /config/scripts

# Ensure scripts are executable
sudo chmod +x /config/user-data/hooks/*

# Generate symlinks to hook script(s)
sudo ln -fs /config/user-data/hooks/* /etc/commit/post-hooks.d/

exit 0
