/*
 * Userspace half of sn2wc: memcpy bandwidth into UC vs WC mappings of
 * DMA32 system memory (GTT-like) and the GPU BAR (VRAM-like), plus checks
 * that WC data actually lands and when it becomes visible without a fence.
 *
 *   gcc -O2 -pthread -o wcbench wcbench.c
 *   ./wcbench mem          # system-memory tests (no GPU driver needed)
 *   ./wcbench bar          # BAR tests (load amdgpu first so VRAM is up)
 */
#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define MB (1UL << 20)
static int fd, wcpu = 1, rcpu = 0;	/* WCB_WCPU / WCB_RCPU override */

static double now(void)
{
	struct timespec t;
	clock_gettime(CLOCK_MONOTONIC, &t);
	return t.tv_sec + t.tv_nsec * 1e-9;
}

static void pin(int cpu)
{
	cpu_set_t s;
	CPU_ZERO(&s);
	CPU_SET(cpu, &s);
	sched_setaffinity(0, sizeof(s), &s);
}

static void *map(int region, unsigned long len)
{
	void *p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
		       (off_t)region << 30);
	if (p == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	return p;
}

/* PIO space only takes <= 8-byte UC loads; glibc memcpy uses 16-byte ldfp8. */
static void read_uc64(void *dst, const void *src, unsigned long len)
{
	const volatile uint64_t *s = src;
	uint64_t *d = dst;

	for (unsigned long i = 0; i < len / 8; i++)
		d[i] = s[i];
}

static void bw(const char *name, int uc_region, int region, unsigned long len, int passes)
{
	char *src = malloc(len), *chk = malloc(len);
	char *dst = map(region, len), *alias = map(uc_region, len);
	double t;
	int i;

	for (i = 0; i < passes; i++) {
		memset(src, 0x11 * (i + 1), len);
		src[i * 4097 % len] ^= 0xff;
	}
	t = now();
	for (i = 0; i < passes; i++)
		memcpy(dst, src, len);
	__sync_synchronize();
	t = now() - t;
	/* verify the last pass through the UC alias */
	read_uc64(chk, alias, len);
	printf("%-28s %8.1f MB/s  %s\n", name, (double)len * passes / t / 1e6,
	       memcmp(chk, src, len) ? "DATA MISMATCH" : "verified via UC alias");
	munmap(dst, len);
	munmap(alias, len);
	free(src);
	free(chk);
}

/* Sub-8-byte stores through WC must not clobber neighbours. */
static void partial(const char *name, int uc_region, int wc_region)
{
	unsigned long len = 64 * 1024, i, bad = 0;
	volatile uint8_t *wc = map(wc_region, len);
	uint8_t *uc = map(uc_region, len), *ref = malloc(len);

	for (i = 0; i < len; i++)
		ref[i] = uc[i] = (uint8_t)(i * 7);
	__sync_synchronize();
	for (i = 3; i + 8 < len; i += 37) {
		switch (i % 4) {
		case 0: wc[i] = 0xa5; ref[i] = 0xa5; break;
		case 1: *(volatile uint16_t *)(wc + (i & ~1UL)) = 0xbeef;
			memcpy(ref + (i & ~1UL), &(uint16_t){0xbeef}, 2); break;
		case 2: *(volatile uint32_t *)(wc + (i & ~3UL)) = 0xdeadbeef;
			memcpy(ref + (i & ~3UL), &(uint32_t){0xdeadbeef}, 4); break;
		case 3: *(volatile uint64_t *)(wc + (i & ~7UL)) = 0x0123456789abcdefULL;
			memcpy(ref + (i & ~7UL), &(uint64_t){0x0123456789abcdefULL}, 8); break;
		}
	}
	__sync_synchronize();
	for (i = 0; i < len; i++)
		bad += uc[i] != ref[i];
	printf("%-28s %s (%lu bad bytes)\n", name, bad ? "PARTIAL STORES BROKEN" : "ok", bad);
	munmap((void *)wc, len);
	munmap(uc, len);
	free(ref);
}

/*
 * Visibility without a fence: CPU 1 stores through WC and then does no
 * memory operations; CPU 0 polls the UC alias. Mesa never fences its WC
 * writes, so this is what it relies on.
 */
struct vis { volatile uint64_t *wc; int mode; volatile int go, done; };

static void *writer(void *arg)
{
	struct vis *v = arg;
	volatile uint64_t spin = 0;
	(void)spin;

	pin(wcpu);
	while (!v->go)
		;
	if (v->mode == 2) {
		for (int i = 0; i < 16; i++)
			v->wc[i] = 0x5a5a5a5a00000000ULL | i;	/* full 128-byte line */
	} else {
		v->wc[0] = 0x5a5a5a5a5a5a5a5aULL;
	}
	if (v->mode == 1)
		__sync_synchronize();
	if (v->mode == 3)
		getppid();					/* a syscall, no explicit fence */
	while (!v->done)
		spin++;
	return NULL;
}

static void visibility(const char *name, int uc_region, int wc_region)
{
	static const char *modes[] = { "8B store, no fence", "8B store + mf",
				       "full line, no fence", "8B store + syscall" };
	for (int mode = 0; mode < 4; mode++) {
		volatile uint64_t *uc = map(uc_region, 1 << 20);
		struct vis v = { .wc = map(wc_region, 1 << 20), .mode = mode };
		pthread_t th;
		double t0, t;
		uint64_t want = mode == 2 ? 0x5a5a5a5a0000000fULL : 0x5a5a5a5a5a5a5a5aULL;
		int idx = mode == 2 ? 15 : 0;

		uc[0] = 0;
		uc[15] = 0;
		__sync_synchronize();
		pin(rcpu);
		pthread_create(&th, NULL, writer, &v);
		usleep(10000);
		t0 = now();
		v.go = 1;
		while (uc[idx] != want && (t = now() - t0) < 3.0)
			;
		t = now() - t0;
		v.done = 1;
		pthread_join(th, NULL);
		printf("%-28s %-22s %s %.1f us\n", name, modes[mode],
		       uc[idx] == want ? "visible after" : "NOT VISIBLE within", t * 1e6);
		munmap((void *)uc, 1 << 20);
		munmap((void *)v.wc, 1 << 20);
	}
}

int main(int argc, char **argv)
{
	const char *mode = argc > 1 ? argv[1] : "mem";
	int bar = !strncmp(mode, "bar", 3);
	unsigned long len = 32 * MB;

	fd = open("/dev/sn2wc", O_RDWR);
	if (fd < 0) {
		perror("/dev/sn2wc");
		return 1;
	}
	setvbuf(stdout, NULL, _IONBF, 0);
	if (getenv("WCB_WCPU"))
		wcpu = atoi(getenv("WCB_WCPU"));
	if (getenv("WCB_RCPU"))
		rcpu = atoi(getenv("WCB_RCPU"));
	pin(wcpu);
	if (!strcmp(mode, "bar-wc1")) {
		/* one 8-byte WC store to the BAR, fenced, then read back via UC */
		volatile uint64_t *wc = map(3, 1 << 20), *uc = map(2, 1 << 20);
		printf("before: 0x%016llx\n", (unsigned long long)uc[0]);
		wc[0] = 0x1122334455667788ULL;
		__sync_synchronize();
		printf("after WC store + mf: 0x%016llx\n", (unsigned long long)uc[0]);
		return 0;
	}
	if (!strcmp(mode, "bar-uc")) {
		bw("memcpy -> VRAM BAR, UC", 2, 2, 8 * MB, 2);
		return 0;
	}
	{
		char *a = malloc(len), *b = malloc(len);
		double t;
		memset(a, 1, len);
		memset(b, 2, len);
		t = now();
		for (int i = 0; i < 4; i++)
			memcpy(b, a, len);
		asm volatile("" :: "r"(b) : "memory");
		printf("%-28s %8.1f MB/s\n", "memcpy WB RAM -> RAM", 4.0 * len / (now() - t) / 1e6);
		free(a);
		free(b);
	}
	if (!bar) {
		bw("memcpy -> DMA32 RAM, UC", 0, 0, len, 2);
		bw("memcpy -> DMA32 RAM, WC", 0, 1, len, 4);
		partial("WC sub-8B stores, RAM", 0, 1);
		visibility("WC visibility, RAM", 0, 1);
		pin(wcpu);
	} else {
		bw("memcpy -> VRAM BAR, UC", 2, 2, 8 * MB, 2);
		bw("memcpy -> VRAM BAR, WC", 2, 3, 8 * MB, 2);
		partial("WC sub-8B stores, BAR", 2, 3);
		visibility("WC visibility, BAR", 2, 3);
	}
	return 0;
}
