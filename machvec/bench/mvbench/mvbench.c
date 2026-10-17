// SPDX-License-Identifier: GPL-2.0
/*
 * mvbench - microbenchmarks for the SN2 runtime machvec dispatch.
 *
 * Times the operations that ia64_is_sn2() sits in front of, in ITC
 * cycles per operation:
 *
 *   empty          loop overhead (subtract from the others)
 *   is_sn2         the bare platform test
 *   readl          readl() of a device register        (needs bdf=)
 *   readl_relaxed  readl_relaxed(), never dispatched   (needs bdf=)
 *   inb            inb() of an I/O port                 (needs port=)
 *   mmiowb         spin_lock; writel; spin_unlock       (needs wscratch=)
 *   ipi            smp_call_function_single() round trip to ipi_cpu
 *
 * Each read of /sys/kernel/debug/mvbench/run does `reps` batches of
 * `iters` operations per test and prints the minimum and median batch,
 * one line per test:
 *
 *   test=readl iters=2000 reps=15 min=1234.56 median=1240.10 unit=itc/op
 *
 * Pick a register whose read has no side effects (e.g. a NIC's
 * identification/status register).  The module builds on kernels with or
 * without asm/machvec.h.
 */

#include <linux/debugfs.h>
#include <linux/delay.h>
#include <linux/irqflags.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/preempt.h>
#include <linux/seq_file.h>
#include <linux/slab.h>
#include <linux/smp.h>
#include <linux/sort.h>
#include <linux/spinlock.h>
#include <linux/utsname.h>
#include <asm/io.h>
#include <asm/processor.h>
#include <asm/timex.h>

#if __has_include(<asm/machvec.h>)
#include <asm/machvec.h>
#endif

#ifndef ia64_platform_is
#define MVB_IS_SN2()	false
#define MVB_HAVE_MV	0
#else
#define MVB_IS_SN2()	ia64_is_sn2()
#define MVB_HAVE_MV	1
#endif

static char *bdf;
module_param(bdf, charp, 0444);
MODULE_PARM_DESC(bdf, "PCI device for readl tests, e.g. 0000:01:00.0");
static int bar;
module_param(bar, int, 0444);
MODULE_PARM_DESC(bar, "BAR of bdf to map (default 0)");
static unsigned long off;
module_param(off, ulong, 0444);
MODULE_PARM_DESC(off, "register offset within the BAR to read");
static long wscratch = -1;
module_param(wscratch, long, 0444);
MODULE_PARM_DESC(wscratch, "offset of a writable scratch register for mmiowb (-1 = skip)");
static long port = -1;
module_param(port, long, 0444);
MODULE_PARM_DESC(port, "I/O port for the inb test (-1 = skip)");
static int ipi_cpu = -1;
module_param(ipi_cpu, int, 0444);
MODULE_PARM_DESC(ipi_cpu, "target CPU for the IPI test (-1 = last online CPU)");
static unsigned int reps = 15;
module_param(reps, uint, 0644);
static unsigned int iters_loop = 1000000;
module_param(iters_loop, uint, 0644);
static unsigned int iters_mmio = 2000;
module_param(iters_mmio, uint, 0644);
static unsigned int iters_ipi = 2000;
module_param(iters_ipi, uint, 0644);

static void __iomem *regs;
static struct pci_dev *pdev;
static struct dentry *dir;
static DEFINE_SPINLOCK(mvb_lock);
static volatile unsigned long sink;

static int cmp_ul(const void *a, const void *b)
{
	unsigned long x = *(const unsigned long *)a, y = *(const unsigned long *)b;

	return x < y ? -1 : x > y;
}

typedef void (*batch_fn)(unsigned int iters);

static void b_empty(unsigned int n)
{
	while (n--)
		barrier();
}

static void b_is_sn2(unsigned int n)
{
	unsigned long c = 0;

	while (n--) {
		if (MVB_IS_SN2())
			c++;
		barrier();
	}
	sink = c;
}

static void b_readl(unsigned int n)
{
	u32 v = 0;

	while (n--)
		v += readl(regs + off);
	sink = v;
}

static void b_readl_relaxed(unsigned int n)
{
	u32 v = 0;

	while (n--)
		v += readl_relaxed(regs + off);
	sink = v;
}

static void b_inb(unsigned int n)
{
	unsigned int v = 0;

	while (n--)
		v += inb(port);
	sink = v;
}

static void b_mmiowb(unsigned int n)
{
	while (n--) {
		spin_lock(&mvb_lock);
		writel(n, regs + wscratch);
		spin_unlock(&mvb_lock);
	}
}

static void ipi_nop(void *info)
{
}

static void b_ipi(unsigned int n)
{
	while (n--)
		smp_call_function_single(ipi_cpu, ipi_nop, NULL, 1);
}

/*
 * Run reps batches; irqs_off batches run with interrupts disabled so a
 * timer tick doesn't land in the middle (keep those batches short).
 */
static void run_test(struct seq_file *m, const char *name, batch_fn fn,
		     unsigned int iters, bool irqs_off)
{
	unsigned long *t, flags, t0, t1;
	unsigned int r;

	t = kcalloc(reps, sizeof(*t), GFP_KERNEL);
	if (!t)
		return;

	fn(iters / 10 + 1);	/* warm caches and the branch predictor */
	for (r = 0; r < reps; r++) {
		preempt_disable();
		if (irqs_off)
			local_irq_save(flags);
		t0 = get_cycles();
		fn(iters);
		t1 = get_cycles();
		if (irqs_off)
			local_irq_restore(flags);
		preempt_enable();
		t[r] = t1 - t0;
		cond_resched();
	}
	sort(t, reps, sizeof(*t), cmp_ul, NULL);

	/* cycles/op with two decimals, in integer arithmetic */
#define CPO(c) (unsigned long)((c) / iters), (unsigned long)(((c) % iters) * 100 / iters)
	seq_printf(m, "test=%s iters=%u reps=%u min=%lu.%02lu median=%lu.%02lu unit=itc/op\n",
		   name, iters, reps, CPO(t[0]), CPO(t[reps / 2]));
#undef CPO
	kfree(t);
}

static int run_show(struct seq_file *m, void *v)
{
	seq_printf(m, "# kernel=%s machvec=%d is_sn2=%d itc_freq=%lu cpu=%d\n",
		   init_utsname()->release, MVB_HAVE_MV, (int)MVB_IS_SN2(),
		   local_cpu_data->itc_freq, raw_smp_processor_id());

	if (!reps)
		return 0;

	run_test(m, "empty", b_empty, iters_loop, true);
	run_test(m, "is_sn2", b_is_sn2, iters_loop, true);
	if (regs) {
		run_test(m, "readl", b_readl, iters_mmio, true);
		run_test(m, "readl_relaxed", b_readl_relaxed, iters_mmio, true);
		if (wscratch >= 0)
			run_test(m, "mmiowb", b_mmiowb, iters_mmio, true);
	}
	if (port >= 0)
		run_test(m, "inb", b_inb, iters_mmio, true);
	if (ipi_cpu >= 0 && cpu_online(ipi_cpu) &&
	    ipi_cpu != raw_smp_processor_id())
		run_test(m, "ipi", b_ipi, iters_ipi, false);
	return 0;
}
DEFINE_SHOW_ATTRIBUTE(run);

static int __init mvbench_init(void)
{
	if (bdf) {
		unsigned int dom, bus, dev, fn;

		if (sscanf(bdf, "%x:%x:%x.%x", &dom, &bus, &dev, &fn) != 4)
			return -EINVAL;
		pdev = pci_get_domain_bus_and_slot(dom, bus, PCI_DEVFN(dev, fn));
		if (!pdev)
			return -ENODEV;
		if (off + 4 > pci_resource_len(pdev, bar) ||
		    (wscratch >= 0 && wscratch + 4 > pci_resource_len(pdev, bar))) {
			pci_dev_put(pdev);
			return -EINVAL;
		}
		regs = pci_iomap(pdev, bar, 0);
		if (!regs) {
			pci_dev_put(pdev);
			return -ENOMEM;
		}
	}
	if (ipi_cpu < 0)
		ipi_cpu = cpumask_last(cpu_online_mask);

	dir = debugfs_create_dir("mvbench", NULL);
	debugfs_create_file("run", 0400, dir, NULL, &run_fops);
	return 0;
}

static void __exit mvbench_exit(void)
{
	debugfs_remove_recursive(dir);
	if (regs)
		pci_iounmap(pdev, regs);
	pci_dev_put(pdev);
}

module_init(mvbench_init);
module_exit(mvbench_exit);
MODULE_DESCRIPTION("SN2 runtime machvec microbenchmarks");
MODULE_LICENSE("GPL");
