#!/bin/bash
# A/B benchmark loop on a grub-booted box (rx2800, hprx): for each grub
# entry, boot it with boot-host.sh, check uname, and run
# /opt/machvec-bench/mvbench.sh <entry> <reps> on the box.  Results stay on
# the box under /opt/machvec-bench/results/<host>/<entry>/boot-*/; fetch them
# with rsync afterwards (MVB_OUT overrides the results root).  Restores grub's default to 0 at the end.
#
#   ab-host.sh <host> <reps> <entry>...   e.g. ab-host.sh rx2800 10 hp-epic hp-generic hp-combined hp-epic hp-generic hp-combined
set -euo pipefail
HOST=${1:?usage: ab-host.sh <host> <reps> <entry>...}
REPS=${2:?}
shift 2
TOOLS=$(cd "$(dirname "$0")/../.." && pwd)

# hp-epic -> -HP-EPIC-, hp-combined -> -HP-MV-, ...
tag() {
	case $1 in
	hp-combined) echo -HP-MV- ;;
	*) echo "-$(echo "$1" | tr a-z A-Z)-" ;;
	esac
}

for e in "$@"; do
	echo "== $HOST: booting $e"
	TIMEOUT=${TIMEOUT:-1500} "$TOOLS/boot-host.sh" "$HOST" "$e" "$(tag "$e")"
	sleep 60	# let boot-time services settle
	ssh root@$HOST "${MVB_OUT:+MVB_OUT=$MVB_OUT }bash /opt/machvec-bench/mvbench.sh $e $REPS 2>&1 | tail -2"
done
"$TOOLS/boot-host.sh" "$HOST" 0 >/dev/null 2>&1 || echo "$HOST: restoring default=0 failed" >&2
echo "== $HOST: done"
