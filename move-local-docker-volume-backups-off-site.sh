#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

base_dir=$(dirname "$0")
readonly base_dir
. "$base_dir/../lib/backup-docker-volumes-locally-and-clean-expired/utils.sh"

if [ "$#" -eq 2 ]
then
        local_backups_dir=$1
        off_site_backups_dir=$2
else
        die "usage: $0 LOCAL_BACKUPS_DIR OFF_SITE_BACKUPS_DIR"
fi
declare -r src
declare -r dest

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

