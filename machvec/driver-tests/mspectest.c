/*
 * mspec driver test: /dev/mspec_cached, /dev/mspec_uncached, /dev/sgi_fetchop.
 *   - fresh pages read as zero, data round-trips, MAP_SHARED is shared across fork
 *   - pages are cleared (mspec_zero_block -> BTE) when the last mapping goes away
 *   - fetchop AMOs: store/load/increment/decrement/clear/and/or, and atomic
 *     increments from several processes at once
 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

#define FETCHOP_VAR_SIZE 64
#define FETCHOP_LOAD      0
#define FETCHOP_INCREMENT 8
#define FETCHOP_DECREMENT 16
#define FETCHOP_CLEAR     24
#define FETCHOP_STORE     0
#define FETCHOP_AND       24
#define FETCHOP_OR        32
#define LD(a, op)     (*(volatile long *)((char *)(a) + (op)))
#define ST(a, op, x)  (*(volatile long *)((char *)(a) + (op)) = (long)(x))

static int fails;
#define CHECK(cond, ...) do { if (!(cond)) { fails++; printf("FAIL: " __VA_ARGS__); printf("\n"); } } while (0)

static void *map(const char *dev, size_t len)
{
	int fd = open(dev, O_RDWR);
	void *p;

	if (fd < 0) { perror(dev); exit(2); }
	p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED) { perror("mmap"); exit(2); }
	close(fd);
	return p;
}

static void test_mem(const char *dev, int rounds)
{
	long pg = sysconf(_SC_PAGESIZE);
	size_t len = 8 * pg, n = len / sizeof(long), i;
	int r;

	for (r = 0; r < rounds; r++) {
		volatile long *p = map(dev, len);
		size_t nz = 0, bad = 0;
		pid_t c;
		int st;

		for (i = 0; i < n; i++)
			if (p[i]) nz++;
		CHECK(nz == 0, "%s round %d: %zu nonzero words in fresh mapping", dev, r, nz);
		for (i = 0; i < n; i++)
			p[i] = (long)(i * 0x9e3779b97f4a7c15UL) ^ r;
		for (i = 0; i < n; i++)
			if (p[i] != ((long)(i * 0x9e3779b97f4a7c15UL) ^ r)) bad++;
		CHECK(bad == 0, "%s round %d: %zu words read back wrong", dev, r, bad);
		/* the child writes, the parent must see it (shared vma_data, refcount) */
		c = fork();
		if (c == 0) {
			for (i = 0; i < n; i += 7)
				p[i] = -1L;
			_exit(0);
		}
		waitpid(c, &st, 0);
		bad = 0;
		for (i = 0; i < n; i += 7)
			if (p[i] != -1L) bad++;
		CHECK(bad == 0, "%s round %d: %zu child writes not visible", dev, r, bad);
		munmap((void *)p, len);
	}
	printf("%s: %d rounds of %zu KB done\n", dev, rounds, len / 1024);
}

static void test_fetchop(int nproc, long iters)
{
	long pg = sysconf(_SC_PAGESIZE);
	void *base = map("/dev/sgi_fetchop", pg);
	void *v = base, *w = (char *)base + FETCHOP_VAR_SIZE;
	long old, i;
	int k, st;

	CHECK(LD(v, FETCHOP_LOAD) == 0, "fetchop: fresh variable is %ld", LD(v, FETCHOP_LOAD));
	ST(v, FETCHOP_STORE, 100);
	CHECK(LD(v, FETCHOP_LOAD) == 100, "fetchop: store/load gave %ld", LD(v, FETCHOP_LOAD));
	old = LD(v, FETCHOP_INCREMENT);
	CHECK(old == 100 && LD(v, FETCHOP_LOAD) == 101, "fetchop: increment returned %ld, now %ld", old, LD(v, FETCHOP_LOAD));
	old = LD(v, FETCHOP_DECREMENT);
	CHECK(old == 101 && LD(v, FETCHOP_LOAD) == 100, "fetchop: decrement returned %ld, now %ld", old, LD(v, FETCHOP_LOAD));
	old = LD(v, FETCHOP_CLEAR);
	CHECK(old == 100 && LD(v, FETCHOP_LOAD) == 0, "fetchop: clear returned %ld, now %ld", old, LD(v, FETCHOP_LOAD));
	ST(w, FETCHOP_STORE, 0xf0f0);
	ST(w, FETCHOP_AND, 0x0ff0);
	CHECK(LD(w, FETCHOP_LOAD) == 0x00f0, "fetchop: and gave %#lx", LD(w, FETCHOP_LOAD));
	ST(w, FETCHOP_OR, 0x0f00);
	CHECK(LD(w, FETCHOP_LOAD) == 0x0ff0, "fetchop: or gave %#lx", LD(w, FETCHOP_LOAD));

	/* atomicity: nproc processes each increment iters times */
	ST(v, FETCHOP_STORE, 0);
	for (k = 0; k < nproc; k++)
		if (fork() == 0) {
			for (i = 0; i < iters; i++)
				(void)LD(v, FETCHOP_INCREMENT);
			_exit(0);
		}
	for (k = 0; k < nproc; k++)
		wait(&st);
	CHECK(LD(v, FETCHOP_LOAD) == nproc * iters, "fetchop: %d x %ld increments gave %ld",
	      nproc, iters, LD(v, FETCHOP_LOAD));
	printf("fetchop: ops ok, %d procs x %ld increments = %ld\n", nproc, iters, LD(v, FETCHOP_LOAD));
	munmap(base, pg);
}

int main(int argc, char **argv)
{
	int rounds = argc > 1 ? atoi(argv[1]) : 50;

	test_mem("/dev/mspec_cached", rounds);
	test_mem("/dev/mspec_uncached", rounds);
	test_fetchop(4, 1000000);
	printf("%s (%d failures)\n", fails ? "FAILED" : "PASSED", fails);
	return fails != 0;
}
