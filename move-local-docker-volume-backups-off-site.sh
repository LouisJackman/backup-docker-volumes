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
    check_not_world_readable "$default_src"

    if [[ ! -d $src ]]
    then
        die "$src is not accessible"
    fi

    if [[ ! -d $dest ]]
    then
        die "$dest is not accessible"
    fi

    if diff <(realpath "$src") <(realpath "$dest") >/dev/null
    then
        die "$src and $dest should not overlap"
    fi
}

missing_in_dest() {
    diff \
        <(ls "$src" | sort) \
        <(ls "$dest" | sort) \
        | awk -F'< ' '{ print $2 }'
}

copy_all() {
    local missing
    while read missing
    do
        echo "$missing is missing; copying..."
        {
            cp "$src/$missing" "$dest/$missing"
            echo "Finished copying $missing"
        } &
    done

    wait
}

main() {
    check

    echo "Copying missing backups from $src to $dest..."
    missing_in_dest | copy_all
    echo "Finished copying from $src to $dest."
}

main

