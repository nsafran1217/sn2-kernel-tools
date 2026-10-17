// SPDX-License-Identifier: GPL-2.0
/*
 * tlbbench - cost of a global TLB purge.
 *
 * A helper thread pinned to CPU B keeps touching a shared page, so the
 * mm stays live on two CPUs.  The main thread, pinned to CPU A, then
 * toggles mprotect() on another page; each call ends in
 * flush_tlb_range() with more than one CPU in mm_cpumask, which is
 * the global purge (ptc.ga on HP, sn2_global_tlb_purge() on SN2).
 *
 *   tlbbench [-a cpu] [-b cpu] [-n iters] [-r reps]
 *
 * Prints one line per rep: "tlbbench rep=N ns_per_op=X".
 * Pick CPUs on different sockets/nodes to include the interconnect.
 * Build on the target: gcc -O2 -pthread -o tlbbench tlbbench.c
 */
#define _GNU_SOURCE
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

static volatile int stop;
static volatile char *shared;

static void pin(int cpu)
{
	cpu_set_t set;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	if (sched_setaffinity(0, sizeof(set), &set)) {
		perror("sched_setaffinity");
		exit(1);
	}
}

static void *toucher(void *arg)
{
	pin(*(int *)arg);
	while (!stop)
		shared[0]++;
	return NULL;
}

static double now_ns(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ts.tv_sec * 1e9 + ts.tv_nsec;
}

int main(int argc, char **argv)
{
	int cpu_a = 0, cpu_b = -1, iters = 20000, reps = 10, c, r, i;
	long pagesz = sysconf(_SC_PAGESIZE);
	pthread_t th;
	char *buf;

	while ((c = getopt(argc, argv, "a:b:n:r:")) != -1) {
		switch (c) {
		case 'a': cpu_a = atoi(optarg); break;
		case 'b': cpu_b = atoi(optarg); break;
		case 'n': iters = atoi(optarg); break;
		case 'r': reps = atoi(optarg); break;
		default:
			fprintf(stderr, "usage: %s [-a cpu] [-b cpu] [-n iters] [-r reps]\n", argv[0]);
			return 1;
		}
	}
	if (cpu_b < 0)
		cpu_b = sysconf(_SC_NPROCESSORS_ONLN) - 1;

	buf = mmap(NULL, 2 * pagesz, PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (buf == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	memset(buf, 0, 2 * pagesz);
	shared = buf;

	pin(cpu_a);
	if (pthread_create(&th, NULL, toucher, &cpu_b)) {
		perror("pthread_create");
		return 1;
	}
	usleep(100000);

	for (r = 0; r < reps; r++) {
		double t0 = now_ns();

		for (i = 0; i < iters; i++) {
			mprotect(buf + pagesz, pagesz, PROT_READ);
			mprotect(buf + pagesz, pagesz, PROT_READ | PROT_WRITE);
		}
		printf("tlbbench rep=%d cpus=%d,%d ns_per_op=%.1f\n", r, cpu_a,
		       cpu_b, (now_ns() - t0) / (2.0 * iters));
	}
	stop = 1;
	pthread_join(th, NULL);
	return 0;
}
