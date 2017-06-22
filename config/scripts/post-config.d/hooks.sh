#!/bin/bash
source /config/user-data/edgerouter-backup.conf

sudo ln -fs /config/user-data/hooks/* /etc/commit/post-hooks.d/
sudo chmod +x /config/user-data/hooks/*
exit 0
