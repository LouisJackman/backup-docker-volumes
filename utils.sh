#!/usr/bin/env bash

die() {
    echo Error: "$@" >&2
    exit 1
}

check_not_world_readable() {
    local dir=$1

    if stat -c '%a' "$dir" | grep -E '[^0]$'
    then
        die "refusing to use local backup directory $dir with world-readable permissions"
    fi
}

check_not_root() {
    local euid
    euid=$(id -u)

    if [[ $euid -eq 0 ]]
    then
        die "should not be run under root; use systemd's sandboxed dynamic users, or a static, limited, and dedicated service account instead"
    fi
}

