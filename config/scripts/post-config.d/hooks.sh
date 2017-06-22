#!/bin/bash
source /configu/user-data/edgerouter-backup.conf

sudo ln -fs /config/user-data/hooks/* /etc/commit/post-hooks.d/
exit 0
