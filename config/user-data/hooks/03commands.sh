#!/bin/bash
source /config/user-data/edgerouter-backup.conf

sudo touch /config/user-data/$FNAME_CONFIG
sudo touch /config/user-data/$FNAME_CLI
sudo chmod 664 /config/user-data/$FNAME_CONFIG
sudo chmod 664 /config/user-data/$FNAME_CLI

sudo cli-shell-api showConfig --show-active-only > /config/user-data/$FNAME_CONFIG
sudo cli-shell-api showConfig --show-commands --show-active-only > /config/user-data/$FNAME_CLI
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CONFIG $SSH_USER@$SSH_HOST:$REPO_PATH/
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CLI $SSH_USER@$SSH_HOST:$REPO_PATH/

sudo ssh -i $SSH_KEYFILE -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST 'bash -s' << ENDSSH
cd $REPO_PATH
git add --all
git commit -m "Auto-commit"
git push
ENDSSH

sudo rm /config/user-data/$FNAME_CONFIG
sudo rm /config/user-data/$FNAME_CLI