# edgerouter-backup

Ubiquiti's EdgeOS provides `system config-management commit-archive location` as a way to push configuration commits to a remote location. For my use, I have two problems with it:

1. Backups are in their brace-y format instead of CLI commands.
2. They use a unique filename for each commit. 

I want to put my configuration files into source control, so maintaining the same filename is preferable. I also find the CLI format to be easier to read and `diff` against.

This backup script hooks into the EdgeRouter `commit` process and generates configuration files in both CLI and brace-y formats, along with a full configuration backup in `.tar.gz` form that is directly restore-able via the management GUI. The files are then sent to a remote server via `scp`, and `git commit` & `git push` are run on the remote server -- avoiding having to install `git` on the EdgeRouter itself. This script can be used along side `config-management` or as a replacement.

These scripts do not modify any EdgeOS-provided files. The locations of all the files will survive reboots and firmware upgrades. I've personally tested this on an ER-8 and ER-X-SFP running v1.9.1.1 firmware and verified firmware survivability by upgrading to v1.9.1.1unms. Should work on any EdgeRouter model. Might work on the USG / USG Pro but that's rather pointless -- back up your UniFi Controller.


### **IMPORTANT**

These configuration dumps **ARE NOT SANITIZED**. They may contain plaintext passwords for some services. **Do not publish to a publicly accessible git repo.**

---

* [Installation](#installation)
* [EdgeRouter Configuration](#edgerouter-configuration)
* [Remote Host Configuration](#remote-host-configuration)
* [Caveats](#caveats)
* [Alternatives](#alternatives)

---

### Installation

Copy contents of `config` directory to `/config` on EdgeRouter.


### EdgeRouter Configuration

Edit `/config/user-data/edgerouter-backup.conf` with your information:

     #!/bin/bash
     
     # Default commit message
     DEFAULT_COMMIT_MESSAGE="Auto commit by edgerouter-backup"

     # Path to private key for SSH / SCP
     SSH_KEYFILE=/config/user-data/backup_user_private.key
     SSH_USER=username
     SSH_HOST=host
     
     # Path to git repo on SSH_HOST
     REPO_PATH=\~/edgerouter-backups

     # Names for EdgeRouter configuration backup files. If you are backing
     # up multiple EdgeRouters to the same place you'll want to ensure that
     # FNAME_BASE is unique to each EdgeRouter
     FNAME_BASE=$HOSTNAME
     
     FNAME_CONFIG=$FNAME_BASE.config.conf
     FNAME_CLI=$FNAME_BASE.commands.conf
     FNAME_BACKUP=$FNAME_BASE.backup.tar.gz

Edit the `SSH_KEYFILE` file to have the private key for `SSH_USER`

`sudo chmod +x /config/scripts/post-config.d/*.sh && sudo /config/scripts/post-config.d/hooks.sh && sudo /config/scripts/post-config.d/ssh_keys.sh`

	 
### Remote Host Configuration

* Make sure your SSH key works for `SSH_USER` (ie: place public key in `~/.ssh/authorized_users`)
* Create git repo in `REPO_PATH`.
* Configure git settings for repo as desired.
* Verify that `git commit -m "Commit Message"` and `git push` execute without interaction.


### Caveats

There's no error-handling in these scripts at all. 

If your `SSH_HOST` is unreachable, the config file won't get pushed and it will not try again. If you're making changes from the command line you will see the errors and can run `sudo /config/user-data/hooks/03-edgerouter-backup.sh` manually to try again.

You could also set up a cron job to perform the push periodically:

     set system task-scheduler task commit-push executable path /config/user-data/hooks/03-edgerouter-backup.sh
     set system task-scheduler task commit-push interval 1h

`git` is smart enough not to `commit` or `push` when no actual changes have been made, however, this script is not -- the backups will be generated and transferred every time `03-edgerouter-backup.sh` runs.


### Alternatives

If you have many EdgeRouters, a proper network configuration management system such as [RANCID](http://www.shrubbery.net/rancid/) or [Oxidized](https://github.com/ytti/oxidized) may be more appropriate.
