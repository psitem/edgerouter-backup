#!/bin/bash
source /config/user-data/edgerouter-backup.conf

COMMIT_VIA=${COMMIT_VIA:-other}
COMMIT_CMT=${COMMIT_COMMENT:-$DEFAULT_COMMIT_MESSAGE}

if [ "$COMMIT_CMT" == "commit" ];
then
    COMMIT_CMT=$DEFAULT_COMMIT_MESSAGE
fi

if [ $# -eq 1 ] && [ $1 = "rollback" ];
then
    COMMIT_VIA="rollback/reboot"
fi

TIME=$(date +%Y-%m-%d" "%H:%M:%S)
USER=$(whoami)

git_commit_msg="$COMMIT_CMT | by $USER | via $COMMIT_VIA | $TIME"

# Generate temporary config files
sudo cli-shell-api showConfig --show-active-only --show-ignore-edit --show-show-defaults > /config/user-data/$FNAME_CONFIG
sudo cli-shell-api showConfig --show-commands --show-active-only --show-ignore-edit --show-show-defaults > /config/user-data/$FNAME_CLI

# Push config files
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CONFIG $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CONFIG
sudo scp -i $SSH_KEYFILE -o StrictHostKeyChecking=no /config/user-data/$FNAME_CLI $SSH_USER@$SSH_HOST:$REPO_PATH/$FNAME_CLI

# git commit and git push on remote host
sudo ssh -i $SSH_KEYFILE -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST 'bash -s' << ENDSSH
cd $REPO_PATH
git add $REPO_PATH/$FNAME_CONFIG
git add $REPO_PATH/$FNAME_CLI
git commit -m "$git_commit_msg"
git push
ENDSSH

# Remove temporary config files
sudo rm /config/user-data/$FNAME_CONFIG
sudo rm /config/user-data/$FNAME_CLI