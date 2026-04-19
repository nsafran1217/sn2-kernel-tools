/*
 * sn2_fsb_test.c — SN2 FSB Saturation Threshold Test (v2)
 *
 * Tests the theory that bulk cache flush operations (fc/GETF) can
 * overflow the SHub PI's FSB transaction table → FSB_PROTO_ERR → MCA.
 *
 * This module does NOT read any SHub registers. It simply:
 *   1. Allocates cacheable pages
 *   2. Dirties them (creates Modified cache lines in CPU L2/L3)
 *   3. Flushes them with ia64_fc() at controlled rates
 *   4. If the system survives → rate is safe
 *   5. If MCA fires → theory confirmed, threshold found
 *
 * Run errdmp AFTER loading if you want the PI error register decode.
 *
 * Parameters:
 *   pages=N      Number of pages to dirty+flush (default 64)
 *   batch=N      Cache lines to flush in one burst (default 32 = 1 page)
 *   delay_us=N   Microseconds to pause between bursts (default 1000)
 *   dry_run=1    Just dirty pages, don't flush (baseline)
 *
 * Start safe (delay_us=1000) and decrease delay to find the threshold.
 * With delay_us=0, this WILL trigger MCA on SN2.
 *
 * Cross-compile:
 *   make ARCH=ia64 CROSS_COMPILE=ia64-linux- -C /path/to/kernel M=$PWD
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/gfp.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/ktime.h>
#include <asm/cacheflush.h>
#include <asm/io.h>

/* ia64_fc — flush one cache line (128 bytes). Generates GETF on FSB. */
#ifndef ia64_fc
#define ia64_fc(addr) asm volatile ("fc %0" :: "r"(addr) : "memory")
#endif
#ifndef ia64_sync_i
#define ia64_sync_i() asm volatile ("sync.i" ::: "memory")
#endif
#ifndef ia64_srlz_i
#define ia64_srlz_i() asm volatile (";; srlz.i ;;" ::: "memory")
#endif

#define IA64_CACHE_LINE 128

static int pages = 64;
module_param(pages, int, 0444);
MODULE_PARM_DESC(pages, "Number of 4KB pages to dirty+flush (default 64)");

static int batch = 32;
module_param(batch, int, 0444);
MODULE_PARM_DESC(batch, "Cache lines per burst before pause (default 32 = 1 page)");

static int delay_us = 1000;
module_param(delay_us, int, 0444);
MODULE_PARM_DESC(delay_us, "Microseconds pause between bursts (default 1000)");

static int dry_run = 0;
module_param(dry_run, int, 0444);
MODULE_PARM_DESC(dry_run, "1=dirty only, skip flush (baseline)");

static int __init sn2_fsb_test_init(void)
{
	struct page **test_pages;
	void **vaddrs;
	int i, line, lines_flushed, total_lines;
	ktime_t t_start, t_dirty, t_flush;
	int batches_done = 0;

	printk(KERN_CRIT "=========================================\n");
	printk(KERN_CRIT "[SN2-FSB-TEST] v2 — no MMR reads\n");
	printk(KERN_CRIT "[SN2-FSB-TEST] pages=%d batch=%d delay_us=%d dry_run=%d\n",
	       pages, batch, delay_us, dry_run);

	total_lines = pages * (PAGE_SIZE / IA64_CACHE_LINE);
	printk(KERN_CRIT "[SN2-FSB-TEST] Total lines=%d (%d KB)\n",
	       total_lines, pages * 4);
	printk(KERN_CRIT "=========================================\n");

	/* Allocate pages */
	test_pages = kmalloc(pages * sizeof(struct page *), GFP_KERNEL);
	vaddrs = kmalloc(pages * sizeof(void *), GFP_KERNEL);
	if (!test_pages || !vaddrs) {
		kfree(test_pages);
		kfree(vaddrs);
		return -ENOMEM;
	}

	for (i = 0; i < pages; i++) {
		test_pages[i] = alloc_page(GFP_KERNEL);
		if (!test_pages[i]) {
			printk(KERN_ERR "[SN2-FSB-TEST] alloc_page failed at %d\n", i);
			while (--i >= 0)
				__free_page(test_pages[i]);
			kfree(test_pages);
			kfree(vaddrs);
			return -ENOMEM;
		}
		vaddrs[i] = page_address(test_pages[i]);
	}
	printk(KERN_INFO "[SN2-FSB-TEST] Allocated %d pages OK\n", pages);

	/* Dirty all pages — write one u64 per cache line to ensure Modified */
	t_start = ktime_get();
	for (i = 0; i < pages; i++) {
		volatile u64 *p = (volatile u64 *)vaddrs[i];
		int j;
		for (j = 0; j < PAGE_SIZE / sizeof(u64); j += IA64_CACHE_LINE / sizeof(u64))
			p[j] = 0xDEAD000000000000ULL | (i << 12) | j;
	}
	mb();
	t_dirty = ktime_get();
	printk(KERN_INFO "[SN2-FSB-TEST] Dirtied %d pages in %lld us\n",
	       pages, ktime_us_delta(t_dirty, t_start));

	if (dry_run) {
		printk(KERN_CRIT "[SN2-FSB-TEST] DRY RUN complete — no flush.\n");
		printk(KERN_CRIT "[SN2-FSB-TEST] Module works. Reload without dry_run.\n");
		goto cleanup;
	}

	/* Flush phase: ia64_fc() each dirty line in batches with pauses.
	 *
	 * Each ia64_fc generates one GETF on the Itanium 2 FSB.
	 * The SHub PI has a finite FSB transaction table.
	 * If we issue fc's faster than the table can drain,
	 * FSB_PROTO_ERR fires → MCA.
	 *
	 * batch=32 delay_us=1000  → 32 GETF then 1ms pause (very safe)
	 * batch=32 delay_us=100   → 32 GETF then 100us pause (moderate)
	 * batch=32 delay_us=0     → 32 GETF then immediate next (aggressive)
	 * batch=9999 delay_us=0   → continuous GETF stream (WILL MCA)
	 */

	printk(KERN_CRIT "[SN2-FSB-TEST] Starting flush: %d lines, batch=%d, delay=%dus\n",
	       total_lines, batch, delay_us);
	printk(KERN_CRIT "[SN2-FSB-TEST] If this is the last message → MCA during flush\n");

	lines_flushed = 0;
	t_dirty = ktime_get();

	for (i = 0; i < pages; i++) {
		unsigned long addr = (unsigned long)vaddrs[i];

		for (line = 0; line < PAGE_SIZE / IA64_CACHE_LINE; line++) {
			ia64_fc((void *)(addr + line * IA64_CACHE_LINE));
			lines_flushed++;

			if ((lines_flushed % batch) == 0) {
				batches_done++;
				if (delay_us > 0)
					udelay(delay_us);

				if ((batches_done % 100) == 0)
					printk(KERN_INFO "[SN2-FSB-TEST] progress: "
					       "%d/%d lines\n",
					       lines_flushed, total_lines);
			}
		}
	}

	ia64_sync_i();
	ia64_srlz_i();

	t_flush = ktime_get();

	printk(KERN_CRIT "=========================================\n");
	printk(KERN_CRIT "[SN2-FSB-TEST] SURVIVED — no MCA\n");
	printk(KERN_CRIT "[SN2-FSB-TEST] %d lines in %lld us (%d batches)\n",
	       lines_flushed,
	       ktime_us_delta(t_flush, t_dirty),
	       batches_done);
	if (ktime_us_delta(t_flush, t_dirty) > 0)
		printk(KERN_CRIT "[SN2-FSB-TEST] Rate: %lld lines/ms\n",
		       (s64)lines_flushed * 1000 /
		       ktime_us_delta(t_flush, t_dirty));
	printk(KERN_CRIT "[SN2-FSB-TEST] Run errdmp to check PI error bits.\n");
	printk(KERN_CRIT "[SN2-FSB-TEST] Try lower delay_us to find threshold.\n");
	printk(KERN_CRIT "=========================================\n");

cleanup:
	for (i = 0; i < pages; i++)
		if (test_pages[i])
			__free_page(test_pages[i]);
	kfree(test_pages);
	kfree(vaddrs);
	return -EAGAIN;
}

static void __exit sn2_fsb_test_exit(void) {}

module_init(sn2_fsb_test_init);
module_exit(sn2_fsb_test_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("SN2 FSB Saturation Test v2");
