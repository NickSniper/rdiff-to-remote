# nicksniper2/rdiff-to-remote-server

<https://github.com/NickSniper/rdiff-to-remote-server>

Available as:

* [`nicksniper2/rdiff-to-remote-server`](https://hub.docker.com/r/nicksniper2/rdiff-to-remote-server)
* [`github.com/NickSniper/rdiff-to-remote-server`](https://github.com/NickSniper/rdiff-to-remote-server)

## Description

Docker image providing backups with [rdiff-backup](http://www.nongnu.org/rdiff-backup/).
The main purpose is to backup local machines to a remote backup server volume. Using rdiff-backup
gives you direct access to the latest version with past versions possible to be
reconstructed using rdiff-backup. Past changes are stored using reverse increments.
Backup runs daily.

Use a config volume `/config` for config files and mount a directory to where
you want to store the backup to `/backup` volume.

To configure what parts of the your machine to be backed up, you can provide
a `/config/backup.list` file which is passed as `include-globbing-filelist` to rdiff-backup.
Example:

```
+ /host/etc
+ /host/home
+ /host/root
+ /host/usr/local/bin
+ /host/usr/local/etc
+ /host/usr/local/sbin
- **/cache
- /host/
```
Please note that `/host` is used only within Docker. It should be added to each folder that starts from the / directory.

This file configures that `/etc`, `/home`, `/root` and parts of `/usr` are backed up, while the
rest of the remote machine is ignored. Any `cache` folders will be ignored everywhere. Consult section *file selection* of
[rdiff-backup man page](http://www.nongnu.org/rdiff-backup/rdiff-backup.1.html)
for more information on the format of this file.


Used environment variables:
 * `RDIFF_BACKUP_TARGET` – remote server where backup will be stored;
   example: `user@example.com::/storage/folder`
 * `/config` - the folder where configurations files stored
   example: `/etc/rdiff-to-remote-server`, or `/mnt/user/appdata/rdiff-to-remote-server`
 * `/host` - the folder from which the files/folders are sourced. If it is "/", then it refers to the root directory. 
   If, for example, it is "/etc", then "/host" inside the Docker container will be equivalent only to the folders inside "/etc".

You should copy your ~/.ssh folder from your ~/.ssh folder to a config folder, to .ssh to make it able 
to connect to the remote server. 

As another option, a SSH key pair should be generated:

```
$ ssh-keygen -t rsa -f backup_rsa
```

Do not set any password on key pair. This generates two files, `backup_rsa` and `backup_rsa.pub`.
You should add (append) contents of the `backup_rsa.pub` file to `~/.ssh/authorized_keys` file on the
remote machine for the user which you are planing to use to connect to the remote machine.
Put both generated files into `/config/.ssh` directory inside the `/config` volume.

Moreover, you should create `known_hosts` file inside `/config/.ssh`, with
the fingerprint of the remote machine's public key:

```
$ ssh-keyscan example.com > known_hosts
```

`/config` volume should generally contain the following files:

```
/config/backup.list
/config/.ssh/backup_rsa
/config/.ssh/backup_rsa.pub
/config/.ssh/known_hosts
```

Remote server should:
 * Have rdiff-backup installed.
 * Have a SSH public key added to user's `~/.ssh/authorized_keys` file.
