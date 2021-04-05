[Unit]
Description=Backup Docker volumes locally and clean expired local backups
After=local-fs.target multi-user.target backup-docker-volumes-locally-and-clean-expired-services.timer

[Service]
ExecStart=DESTDIR_PREFIX/bin/backup-docker-volumes-locally-and-clean-expired.sh ${BACKUP_DOCKER_VOLUMES_LOCAL_BACKUPS_DIR} $BACKUP_DOCKER_VOLUMES_VOLUME_NAMES
Type=OneShot

DynamicUser=true
LockPersonality=true
MemoryDenyWriteExecute=true
PrivateDevices=true
PrivateMounts=true
PrivateTmp=true
PrivateUsers=true
ProtectClock=true
ProtectControlGroups=true
ProtectHome=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectProc=noaccess
ProtectSystem=strict
ReadOnlyPaths=/var/docker/volumes
ReadWritePaths=/var/backups/docker-volumes
RestrictNamespaces=cgroup ipc net mnt pid user uts

[Install]
WantedBy=multi-user.target

