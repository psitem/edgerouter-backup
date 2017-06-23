#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# Generate symlinks to hook script(s)
sudo ln -fs /config/user-data/hooks/* /etc/commit/post-hooks.d/

# Ensure scripts are executable
sudo chmod +x /config/user-data/hooks/*
exit 0
