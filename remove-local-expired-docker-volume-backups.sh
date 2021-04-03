#!/usr/bin/env sh

set -o errexit
set -o nounset

base_dir=$(dirname "$0")
readonly base_dir
. "$base_dir/../lib/backup-docker-volumes-locally-and-clean-expired/utils.sh"

if [ "$#" -eq 1 ]
then
    local_backups_dir=$1
else
    die "usage: $0 LOCAL_BACKUPS_DIR"
fi

check() {
    check_not_root
    check_not_world_readable "$local_backups_dir"

    if [ ! -d "$local_backups_dir" ]
    then
        die "$local_backups_dir"
    fi
}

get_expired_backups() {
    ls "$local_backups_dir" \
        | sort -r \
        | tail +10
}

rm_all() {
    local expired
    while read expired
    do
        echo "Deleting expired backup $expired..."
        rm "$expired"
    done

    wait
}

main() {
    check

    echo "Removing expired backups in $local_backups_dir"
    get_expired_backups | rm_all
    echo "Finished removing expired backups in $local_backups_dir"
}

main

