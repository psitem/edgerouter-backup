#!/bin/bash
source /config/user-data/edgerouter-backup.conf

# This script runs during the commit

# Pull commit info
COMMIT_VIA=${COMMIT_VIA:-other}
COMMIT_CMT=${COMMIT_COMMENT:-$DEFAULT_COMMIT_MESSAGE}

# If no comment, replace with default
if [ "$COMMIT_CMT" == "commit" ];
then
    COMMIT_CMT=$DEFAULT_COMMIT_MESSAGE
fi

# Check if rollback
if [ $# -eq 1 ] && [ $1 = "rollback" ];
then
    COMMIT_VIA="rollback/reboot"
fi

TIME=$(date +%Y-%m-%d" "%H:%M:%S)
USER=$(whoami)

GIT_COMMIT_MSG="$COMMIT_CMT | by $USER | via $COMMIT_VIA | $TIME"

# Generate temporary config files
sudo cli-shell-api showConfig --show-active-only --show-ignore-edit --show-show-defaults > /tmp/edgerouter-backup-$FNAME_CONFIG
sudo cli-shell-api showConfig --show-commands --show-active-only --show-ignore-edit --show-show-defaults > /tmp/edgerouter-backup-$FNAME_CLI

# Push config files
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /tmp/edgerouter-backup-$FNAME_CONFIG $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CONFIG
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /tmp/edgerouter-backup-$FNAME_CLI $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CLI

# git commit and git push on remote host
sudo ssh -i $SSH_KEYFILE -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST 'bash -s' << ENDSSH
cd $REPO_PATH
git add $REPO_PATH/$FNAME_CONFIG
git add $REPO_PATH/$FNAME_CLI
git commit -m "$GIT_COMMIT_MSG"
git push
ENDSSH

# Remove temporary files
sudo rm /tmp/edgerouter-backup-$FNAME_CONFIG
sudo rm /tmp/edgerouter-backup-$FNAME_CLI