#!/usr/bin/env sh

set -o errexit
set -o nounset

base_dir=$(dirname "$0")
readonly base_dir
. "$base_dir/../lib/backup-docker-volumes-locally-and-clean-expired/utils.sh"

readonly docker_volumes_dir="/var/lib/docker/volumes"

if [ 1 -le "$#" ]
then
	readonly local_backups_dir=$1
else
	die "usage: $0 LOCAL_BACKUPS_DIR VOLUME_NAMES..."
fi
shift

readonly volume_names="$*"

check() {
    check_not_root
    check_not_world_readable "$local_backups_dir"

    if [ ! -d "$docker_volumes_dir" ]
    then
        die "cannot access $docker_volumes_dir, likely due to a lack of permissions"
    fi
}

get_backup_dir_for_now() {
    local date
    date=$(date +"%Y-%m-%dT%H:%M:%S")

    mkdir "$local_backups_dir/$date"
    echo "$local_backups_dir/$date"
}

backup() {
    local dated_backup_dir=$1

    echo Starting backups...

    for volume_name in $volume_names
    do
        if [ ! -d "$docker_volumes_dir/$volume_name" ]
        then
            die "expected directory $docker_volumes_dir/$volume_name for $volume_name is not accessible; no volumes were copied"
        fi
    done

    for volume_name in $volume_names
    do
        echo "Backing up $volume_name..."
        {
            tar -Jcf "$dated_backup_dir/$volume_name".tar.xz "$docker_volumes_dir/$volume_name"
            echo "Finished backing up to $dated_backup_dir/$volume_name.tar.xz"
        } &
    done
    wait

    echo All backups finished.
}

main() {
    echo Starting Docker volume backup...
    mkdir -p "$local_backups_dir"

    echo Checking directory access and user...
    check
    echo Access confirmed.

    local dated_backup_dir
    dated_backup_dir=$(get_backup_dir_for_now)
    echo "Created backup directory $dated_backup_dir."

    backup "$dated_backup_dir"

    echo "Finished backing up."
}

main

