#!/bin/bash -e

if [ -z "$RDIFF_BACKUP_TARGET" ]; then
  echo "\"RDIFF_BACKUP_TARGET\" environment variable not set."
  exit 1
fi

# One should mount a file with configuration /config/backup.list to configure precisely what to backup.
if [ ! -e /config/backup.list ]; then
  touch /config/backup.list
fi

cp -R /config/.ssh /root/

# We grep out UpdateError errors because they are not really actionable and happen quite
# often when backing up active files like logs and databases.
/usr/bin/rdiff-backup --include-globbing-filelist /config/backup.list /host "$RDIFF_BACKUP_TARGET" 2>&1
#/usr/bin/rdiff-backup --version

