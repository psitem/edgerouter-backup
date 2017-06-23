#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# Generate temporary config files
sudo cli-shell-api showConfig --show-active-only --show-ignore-edit > /config/user-data/$FNAME_CONFIG
sudo cli-shell-api showConfig --show-commands --show-active-only --show-ignore-edit > /config/user-data/$FNAME_CLI

# Push config files
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CONFIG $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CONFIG
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CLI $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CLI

# git commit and git push on remote host
sudo ssh -i $SSH_KEYFILE -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST 'bash -s' << ENDSSH
cd $REPO_PATH
git add --all
git commit -m "Auto-commit"
git push
ENDSSH

# Remove temporary config files
sudo rm /config/user-data/$FNAME_CONFIG
sudo rm /config/user-data/$FNAME_CLI