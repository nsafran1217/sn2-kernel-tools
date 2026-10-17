#!/usr/bin/env python3
"""Compare machvec benchmark results between two kernels.

usage: mvbench-compare.py BASELINE_DIR CANDIDATE_DIR [--threshold PCT]

Each DIR is a <host>/<label> directory written by mvbench.sh (it holds one
boot-*/results.csv per boot); every results.csv below it is pooled.

For each (bench, metric) prints the baseline and candidate medians, IQRs,
the relative change of the median, and a bootstrap 95% confidence interval
for that change.  A row is flagged REGRESSION/IMPROVEMENT when the interval
excludes zero and the change exceeds --threshold percent (default 1) in the
"better" direction recorded with the metric.  Stdlib only.

lmbench runs each test for a fixed time, so its perf instruction and cycle
totals scale with the iteration count and are not per operation.  For the
single-threaded tests in DERIVE, each rep also gets <metric>.ipo =
instructions * latency / cycles, which is instructions per operation
divided by the core clock in MHz (constant per host).  This assumes the
benchmark keeps its CPU busy for the whole run.

--exclude REGEX drops benches whose name matches (e.g. lat_proc).
"""

import argparse
import csv
import pathlib
import random
import re
import statistics
import sys

# single-threaded lmbench tests that keep one CPU busy: bench -> metric
DERIVE = {"lat_syscall": "null", "lat_pagefault": "file", "lat_mmap": "64m"}


def load(d, exclude=None):
    rows = {}
    files = sorted(pathlib.Path(d).rglob("results.csv"))
    if not files:
        sys.exit(f"no results.csv under {d}")
    kernels, boots = set(), set()
    for f in files:
        perrep = {}
        with open(f, newline="") as fh:
            for r in csv.DictReader(fh):
                if exclude and exclude.search(r["bench"]):
                    continue
                try:
                    v = float(r["value"])
                except (ValueError, TypeError):
                    continue
                key = (r["bench"], r["metric"])
                ent = rows.setdefault(key, {"unit": r["unit"], "better": r["better"], "v": []})
                ent["v"].append(v)
                perrep[(r["bench"], r["metric"], r["rep"])] = v
                kernels.add(r["kernel"])
                boots.add(r["boot"])
        for (b, m, rep), lat in list(perrep.items()):
            if DERIVE.get(b) != m:
                continue
            i = perrep.get((b, m + ".instructions", rep))
            c = perrep.get((b, m + ".cycles", rep))
            if i and c:
                ent = rows.setdefault((b, m + ".ipo"), {"unit": "i/op/MHz", "better": "lower", "v": []})
                ent["v"].append(i * lat / c)
    return rows, kernels, boots


def iqr(v):
    if len(v) < 4:
        return 0.0
    q = statistics.quantiles(v, n=4)
    return q[2] - q[0]


def boot_ci(a, b, n=4000, seed=1):
    """95% CI of (median(b) - median(a)) / median(a), in percent."""
    rng = random.Random(seed)
    ma = statistics.median(a)
    if ma == 0:
        return (0.0, 0.0)
    d = []
    for _ in range(n):
        ra = [rng.choice(a) for _ in a]
        rb = [rng.choice(b) for _ in b]
        m = statistics.median(ra)
        if m:
            d.append((statistics.median(rb) - m) / m * 100)
    d.sort()
    return d[int(0.025 * len(d))], d[int(0.975 * len(d)) - 1]


def fmt(x):
    return f"{x:.4g}"


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("baseline")
    ap.add_argument("candidate")
    ap.add_argument("--threshold", type=float, default=1.0)
    ap.add_argument("--exclude", help="regex of bench names to drop")
    args = ap.parse_args()
    ex = re.compile(args.exclude) if args.exclude else None

    A, ka, ba = load(args.baseline, ex)
    B, kb, bb = load(args.candidate, ex)
    print(f"baseline : {args.baseline}  kernels={sorted(ka)} boots={len(ba)}")
    print(f"candidate: {args.candidate}  kernels={sorted(kb)} boots={len(bb)}")
    print()
    hdr = f"{'bench':<14} {'metric':<22} {'unit':<8} {'n':>7} {'base med':>11} {'±iqr':>9} " \
          f"{'cand med':>11} {'±iqr':>9} {'change':>8} {'95% CI':>18}  verdict"
    print(hdr)
    print("-" * len(hdr))
    flagged = 0
    for key in sorted(set(A) & set(B)):
        a, b = A[key]["v"], B[key]["v"]
        unit, better = A[key]["unit"], A[key]["better"]
        ma, mb = statistics.median(a), statistics.median(b)
        chg = (mb - ma) / ma * 100 if ma else 0.0
        lo, hi = boot_ci(a, b)
        verdict = ""
        if (lo > 0 or hi < 0) and abs(chg) > args.threshold:
            worse = chg > 0 if better == "lower" else chg < 0
            verdict = "REGRESSION" if worse else "improvement"
            flagged += worse
        print(f"{key[0]:<14} {key[1]:<22} {unit:<8} {len(a):>3}/{len(b):<3} {fmt(ma):>11} "
              f"{fmt(iqr(a)):>9} {fmt(mb):>11} {fmt(iqr(b)):>9} {chg:>+7.2f}% "
              f"[{lo:>+6.2f},{hi:>+6.2f}]%  {verdict}")
    only = sorted(set(A) ^ set(B))
    if only:
        print("\nonly in one run:", ", ".join("/".join(k) for k in only))
    print(f"\n{flagged} regression(s) beyond {args.threshold}% with a CI excluding 0")
    return 1 if flagged else 0


if __name__ == "__main__":
    sys.exit(main())
