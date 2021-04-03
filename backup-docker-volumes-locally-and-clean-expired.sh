#!/usr/bin/env sh

set -o errexit
set -o nounset

base_dir=$(dirname "$0")
readonly base_dir
. "$base_dir/../lib/backup-docker-volumes-locally-and-clean-expired/utils.sh"

if [ 1 -le "$#" ]
then
	readonly local_backups_dir=$1
else
	die "usage: $0 LOCAL_BACKUPS_DIR VOLUME_NAMES..."
fi
shift

"$base_dir"/backup-docker-volumes-locally.sh "$local_backups_dir" "$@"
"$base_dir"/remove-local-expired-docker-voume-backups.sh "$local_backups_dir"

