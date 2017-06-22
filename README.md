# edgerouter-backup

These are my backup scripts for hooking into the EdgeRouter `commit` process, pushing the configuration to a remote host, and remotely executing a `git commit` and `git push`. This depends on having `git` and a git repo configured on the remote host, not the EdgeRouter. This can be using along side `system config-management commit-archive location` or as a replacement.

These scripts do not modify any Ubiquiti-provided files. The locations of all the files will surivive reboots and should surivive a firmware upgrade (untested). I've personally tested this on an ER-8 and ER-X-SFP running v1.9.1 firmware. Should work on any EdgeRouter, might work on the USG / USG Pro as well.

### **IMPORTANT**

These configuration dumps **ARE NOT SANITIZED**. They may contain plaintext passwords for some services. **Do not publish to a publicly accessible git repo.**

### Installation

Copy contents of `config` directory to `/config` on EdgeRouter.

### Configuration

Edit `/config/user-data/edgerouter-backup.conf` with your information:

     #!/bin/bash

     # Path to private key for SSH / SCP
     SSH_KEYFILE=/config/user-data/backup_user_private.key
     SSH_USER=username
     SSH_HOST=host
     
     # Path to git repo on SSH_HOST
     REPO_PATH=\~/edgerouter-backup

     # Names for EdgeRouter configuration backup files.
     FNAME_CONFIG=$HOSTNAME.config.conf
     FNAME_CLI=$HOSTNAME.commands.conf

     
### Remote Host Setup

* Make sure your SSH key works.

* Create git repo in `REPO_PATH`.

* Configure repo as desired.

* Verify that `git commit -m "Commit Message"` and `git push` execute without interaction.
