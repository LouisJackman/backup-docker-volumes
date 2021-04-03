# Backup Docker Volumes

Backup Docker volumes locally and cleanup old local backups daily. Provide a
manually-invoked script for moving local backups onto an off-site location.

## Installation

Install with the usual `make && make install`, which will likely need `sudo`.

It needs POSIX, Bash, systemd, and Docker.

## Usage

Once installed, enable with `systemctl enable --now
backup-docker-volumes-locally-and-clean-expired`. From then onwards, it will
backup locally and delete expired backups daily.

Some off-site backups have transient connectivity, e.g. to USB drives that are
plugged in on-site and then moved off-site. As such, migrating those backups is
triggered manually with the dedicated command.

### Commands

Of these commands, only the first one must be run manually. The others are best
scheduled daily by installing the systemd service and timer.

For the local backups directory, `/var/backups/docker-volumes` is a reasonable
choice.

#### `move-local-docker-volume-backups-off-site`

Usage:

```
move-local-docker-volume-backups-off-site LOCAL_BACKUPS_DIR OFF_SITE_BACKUPS_DIR
```

Move missing accumulated local backups from `LOCAL_BACKUPS_DIR` to an off-site
directory provided as `OFF_SITE_BACKUPS_DIR`.

#### `backup-docker-volumes-locally`

Usage:

```
backup-docker-volumes-locally LOCAL_BACKUPS_DIR VOLUME_NAMES...
```

Back up the specified Docker volumes to the local backups directory, uniquely
identified by a timestamp.

#### `remove-local-expired-docker-volume-backups`

Usage:

```
remove-local-expired-docker-volume-backups LOCAL_BACKUPS_DIR
```

Remove expired backups, specifically all but the last ten backups.

#### `backup-docker-volumes-locally-and-clean-expired`

Usage:

```
backup-docker-volumes-locally-and-clean-expired LOCAL_BACKUPS_DIR VOLUME_NAMES...
```

Do both `backup-docker-volumes-locally` and then
`remove-local-expired-docker-volume-backups` in one go.

