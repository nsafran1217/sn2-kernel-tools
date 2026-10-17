#!/bin/bash
# A/B benchmark loop on pople: for each label, point elilo.conf's default
# at mv-<label>, boot it with `altix boot`, check uname, and run
# /opt/machvec-bench/mvbench.sh <label> <reps>.  Results go to the shared
# /opt/machvec-bench/results/pople/<label>/boot-*/.
#
#   ab-pople.sh <reps> <label>...      e.g. ab-pople.sh 10 sn2only combined sn2only combined
#
# Leaves elilo.conf's default at the last label.  Needs the altix tool on
# PATH and the nl4r environment (ALTIX_L2_HOST etc.).
# MVB_ONLY and MVB_OUT are passed through to mvbench.sh.
set -euo pipefail
REPS=${1:?usage: ab-pople.sh <reps> <label>...}
shift
BOOTSERVER=10.40.0.121
ELILO=/t2/tftproot/elilo.conf

declare -A TAG=([combined]=SN2-MV [mvpda]=SN2-MVPDA [sn2only]=SN2-ONLY [generic]=GENERIC)

for label in "$@"; do
	ssh $BOOTSERVER "sed -i 's/^default=.*/default=mv-$label/' $ELILO"
	cur=$(altix ssh 'uname -r' 2>/dev/null || true)
	if [[ $cur == *"-${TAG[$label]}-"* ]] && [ "${FRESH:-1}" = 0 ]; then
		echo "== $label already running ($cur)"
	else
		echo "== booting mv-$label"
		altix boot --label "ab-pople mv-$label" --timeout 900
		cur=$(altix ssh 'uname -r')
	fi
	[[ $cur == *"-${TAG[$label]}-"* ]] || { echo "expected ${TAG[$label]}, running $cur" >&2; exit 1; }
	# let boot-time services settle
	sleep 60
	altix ssh "MVB_ONLY='${MVB_ONLY:-}' MVB_OUT='${MVB_OUT:-/opt/machvec-bench/results}' bash /opt/machvec-bench/mvbench.sh $label $REPS 2>&1 | tail -2"
done
