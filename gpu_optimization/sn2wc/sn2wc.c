// SPDX-License-Identifier: GPL-2.0
/*
 * sn2wc: measure CPU store bandwidth into GPU-visible memory on SN2 with
 * different memory attributes, without involving the GPU driver.
 *
 * /dev/sn2wc mmap offsets (bytes):
 *   0 << 30  DMA32 node-0 pages, UC      (what TTM gives GTT today)
 *   1 << 30  same pages, WC
 *   2 << 30  GPU BAR0 window, UC         (what TTM gives VRAM today)
 *   3 << 30  same BAR0 window, WC
 * The BAR window is bar_off..bar_off+bar_len inside BAR0 of the first
 * 1002:* display device.
 */
#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <linux/pci.h>
#include <linux/vmalloc.h>
#include <asm/sn/arch.h>

static unsigned int mem_mb = 64;
module_param(mem_mb, uint, 0444);
static unsigned long bar_off = 128UL << 20;
module_param(bar_off, ulong, 0444);
static unsigned long bar_len = 64UL << 20;
module_param(bar_len, ulong, 0444);

static struct page **pages;
static unsigned long npages;
static phys_addr_t bar_phys;

static int sn2wc_mmap(struct file *f, struct vm_area_struct *vma)
{
	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
	unsigned long len = vma->vm_end - vma->vm_start;
	unsigned int region = off >> 30;
	unsigned long roff = off & ((1UL << 30) - 1);
	pgprot_t prot = (region & 1) ? pgprot_writecombine(vma->vm_page_prot)
				     : pgprot_noncached(vma->vm_page_prot);
	unsigned long i;
	int ret;

	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
	vma->vm_page_prot = prot;

	switch (region) {
	case 0:
	case 1:
		if (roff + len > npages << PAGE_SHIFT)
			return -EINVAL;
		for (i = 0; i < len >> PAGE_SHIFT; i++) {
			ret = remap_pfn_range(vma, vma->vm_start + (i << PAGE_SHIFT),
					      page_to_pfn(pages[(roff >> PAGE_SHIFT) + i]),
					      PAGE_SIZE, prot);
			if (ret)
				return ret;
		}
		return 0;
	case 2:
	case 3:
		if (!bar_phys || roff + len > bar_len)
			return -EINVAL;
		return io_remap_pfn_range(vma, vma->vm_start,
					  (bar_phys + roff) >> PAGE_SHIFT, len, prot);
	}
	return -EINVAL;
}

static const struct file_operations sn2wc_fops = {
	.owner = THIS_MODULE,
	.mmap = sn2wc_mmap,
};

static struct miscdevice sn2wc_dev = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "sn2wc",
	.fops = &sn2wc_fops,
	.mode = 0600,
};

static void sn2wc_free(void)
{
	unsigned long i;

	for (i = 0; i < npages; i++)
		if (pages[i])
			__free_page(pages[i]);
	vfree(pages);
}

static int __init sn2wc_init(void)
{
	struct pci_dev *pdev = NULL;
	unsigned long i;
	int ret;

	npages = ((unsigned long)mem_mb << 20) >> PAGE_SHIFT;
	pages = vzalloc(npages * sizeof(*pages));
	if (!pages)
		return -ENOMEM;
	for (i = 0; i < npages; i++) {
		/* Same as TTM on SN2: DMA32 (= PIC direct32 window), zeroed, flushed. */
		pages[i] = alloc_pages_node(0, GFP_KERNEL | __GFP_DMA32 | __GFP_ZERO, 0);
		if (!pages[i]) {
			sn2wc_free();
			return -ENOMEM;
		}
		sn_flush_all_caches((long)page_address(pages[i]), PAGE_SIZE);
	}

	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev))) {
		if (pdev->vendor == PCI_VENDOR_ID_ATI && pci_resource_len(pdev, 0)) {
			/* SN2 resource starts carry region bits; the PTE takes 50-bit phys. */
			bar_phys = (pci_resource_start(pdev, 0) & ((1UL << 50) - 1)) + bar_off;
			if (bar_off + bar_len > pci_resource_len(pdev, 0))
				bar_len = pci_resource_len(pdev, 0) - bar_off;
			pci_dev_put(pdev);
			break;
		}
	}

	ret = misc_register(&sn2wc_dev);
	if (ret) {
		sn2wc_free();
		return ret;
	}
	pr_info("sn2wc: %lu pages (first pfn phys 0x%llx), BAR window phys 0x%llx len 0x%lx\n",
		npages, (unsigned long long)page_to_phys(pages[0]),
		(unsigned long long)bar_phys, bar_len);
	return 0;
}

static void __exit sn2wc_exit(void)
{
	misc_deregister(&sn2wc_dev);
	sn2wc_free();
}

module_init(sn2wc_init);
module_exit(sn2wc_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("SN2 UC vs WC store bandwidth test");
