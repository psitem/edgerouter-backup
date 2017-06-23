#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# This script runs at boot of the EdgeRouter

# Generate symlinks to hook script(s)
sudo ln -fs /config/user-data/hooks/* /etc/commit/post-hooks.d/

# Ensure scripts are executable
sudo chmod +x /config/user-data/hooks/*
exit 0