#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s inherit_errexit

base_dir=$(dirname "$BASH_SOURCE")
readonly base_dir
source "$base_dir/../lib/backup-docker-volumes/utils.sh"

if [[ $# -eq 2 ]]
then
    local_backups_dir=$1
    off_site_backups_dir=$2
else
    die "usage: $BASH_SOURCE LOCAL_BACKUPS_DIR OFF_SITE_BACKUPS_DIR"
fi
readonly src
readonly dest

check() {
    check_not_root
    check_not_world_readable "$local_backups_dir"

    if [[ ! -d $local_backups_dir ]]
    then
        die "$local_backups_dir is not accessible"
    fi

    if [[ ! -d $off_site_backups_dir ]]
    then
        die "$off_site_backups_dir is not accessible"
    fi

    if diff <(realpath "$local_backups_dir") <(realpath "$off_site_backups_dir") >/dev/null
    then
        die "$local_backups_dir and $off_site_backups_dir should not overlap"
    fi
}

missing_in_dest() {
    diff \
        <(ls "$local_backups_dir" | sort) \
        <(ls "$off_site_backups_dir" | sort) \
	| tail +2 \
        | awk -F'< ' '{ print $2 }'
}

copy_all() {
    local missing
    while read missing
    do
        echo "$missing is missing; copying..."
        {
            cp -R "$local_backups_dir/$missing" "$off_site_backups_dir/$missing"
            echo "Finished copying $missing"
        } &
    done

    wait
}

main() {
    check

    echo "Copying missing backups from $local_backups_dir to $off_site_backups_dir..."
    missing_in_dest | copy_all
    echo "Finished copying from $local_backups_dir to $off_site_backups_dir."
}

main

