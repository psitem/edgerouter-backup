#!/bin/bash

SSH_USER=""
SSH_HOST=""
SSH_KEYFILE=/config/user-data/backup_user_private.key
REPO_PATH=\~/edgerouter-backup/

sudo touch /config/user-data/$HOSTNAME.config.conf
sudo touch /config/user-data/$HOSTNAME.commands.conf
sudo chmod 664 /config/user-data/$HOSTNAME.config.conf
sudo chmod 664 /config/user-data/$HOSTNAME.commands.conf

sudo cli-shell-api showConfig --show-active-only > /config/user-data/$HOSTNAME.config.conf
sudo cli-shell-api showConfig --show-commands --show-active-only > /config/user-data/$HOSTNAME.commands.conf
scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$HOSTNAME.*.conf $SSH_USER@$SSH_HOST:$REPO_PATH/

ssh -i $SSH_KEYFILE -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST 'bash -s' << ENDSSH
cd $REPO_PATH
git add --all
git commit -m "Auto-commit"
git push
ENDSSH

sudo rm /config/user-data/$HOSTNAME.config.conf
sudo rm /config/user-data/$HOSTNAME.commands.conf
