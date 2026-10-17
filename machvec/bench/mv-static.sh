#!/bin/bash
# Static comparison of two built kernel trees (no hardware needed).
#
# usage: mv-static.sh <baseline> <candidate>
#
# Each argument is a built kernel tree or an artifact dir saved from one
# (vmlinux, vmlinux.o, .config, include/config/kernel.release, and
# optionally the modules' .ko files).
#
# Prints vmlinux section sizes, scripts/bloat-o-meter output, the number of
# ia64_sn2_platform tests compiled into vmlinux and modules (each runtime
# ia64_is_sn2() site loads the key through one LTOFF22X relocation), and
# any SN2 symbols left in a kernel that should have none.

set -uo pipefail
A=$(cd "${1:?usage: mv-static.sh <baseline-tree> <candidate-tree>}" && pwd)
B=$(cd "${2:?}" && pwd)
OBJDUMP=${OBJDUMP:-ia64-linux-objdump}
SIZE=${SIZE:-ia64-linux-size}
NM=${NM:-ia64-linux-nm}
BLOAT=${BLOAT:-$(ls "$B/scripts/bloat-o-meter" "$A/scripts/bloat-o-meter" \
	~/projects/altix_cross/src/mainline/linux-sn2/scripts/bloat-o-meter 2>/dev/null | head -1)}

key_sites() { # tree
	local n=0 m=0 f
	[ -f "$1/vmlinux.o" ] && n=$($OBJDUMP -dr "$1/vmlinux.o" | grep -c 'LTOFF22X[[:space:]]*ia64_sn2_platform')
	while IFS= read -r f; do
		m=$((m + $($OBJDUMP -dr "$f" | grep -c 'LTOFF22X[[:space:]]*ia64_sn2_platform')))
	done < <(find "$1" -name '*.ko' 2>/dev/null)
	echo "vmlinux=$n modules=$m"
}

mod_text() { # tree: total .text of all modules
	find "$1" -name '*.ko' -print0 2>/dev/null | xargs -0r $SIZE 2>/dev/null |
		awk 'NR > 1 { t += $1 } END { print t + 0 }'
}

for t in "$A" "$B"; do
	echo "== $t"
	echo "   $(cat "$t/include/config/kernel.release" 2>/dev/null)  $(grep -E '^(CONFIG_IA64_SGI_SN2|CONFIG_IA64_SGI_SN2_ONLY)=' "$t/.config" | tr '\n' ' ')"
	$SIZE "$t/vmlinux" | sed 's/^/   /'
	echo "   module text total: $(mod_text "$t")"
	echo "   ia64_sn2_platform tests: $(key_sites "$t")"
	if ! grep -q '^CONFIG_IA64_SGI_SN2=y' "$t/.config"; then
		echo "   SN2 symbols (should be none): $($NM "$t/vmlinux" | grep -cE ' (sn_|sn2_|___sn_)')"
	fi
done

echo
echo "== bloat-o-meter $A -> $B"
"$BLOAT" "$A/vmlinux" "$B/vmlinux" | sed -n '1,40p'
