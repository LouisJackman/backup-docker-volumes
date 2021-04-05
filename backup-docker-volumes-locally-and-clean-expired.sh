#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s inherit_errexit

base_dir=$(dirname "$BASH_SOURCE")
readonly base_dir
source "$base_dir/../lib/backup-docker-volumes/utils.sh"

if [[ 1 -le $# ]]
then
	readonly local_backups_dir=$1
else
	die "usage: $BASH_SOURCE LOCAL_BACKUPS_DIR VOLUME_NAMES..."
fi
shift

"$base_dir"/backup-docker-volumes-locally "$local_backups_dir" "$@"
"$base_dir"/remove-local-expired-docker-volume-backups "$local_backups_dir"

