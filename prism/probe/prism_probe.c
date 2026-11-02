// SPDX-License-Identifier: GPL-2.0
/*
 * prism_probe: look at a TIO CA and the card behind it without loading radeon.
 *
 * Nothing on this path has run on a modern kernel, so each step that touches
 * hardware is a separate parameter and is off by default.  Load one step at a
 * time, in the order below, and read dmesg in between.  If the box dies, the
 * last step named on the console is the one that did it.
 *
 *   insmod prism_probe.ko                  config space and software state
 *   insmod prism_probe.ko ca_regs=1        CA registers
 *   insmod prism_probe.ko gpu_regs=1       card registers through BAR2
 *   insmod prism_probe.ko io_regs=1        card registers through the I/O BAR
 *   insmod prism_probe.ko rom_test=1       ROM with its enable bit set
 *   insmod prism_probe.ko rom_off=1        ROM with its enable bit clear
 *   insmod prism_probe.ko rom_dump=1       copy the ROM to debugfs
 *
 * rmmod between runs.  Reading a BAR with Memory Space off is refused unless
 * enable_mem=1 is given: that sets the bit for the step and restores it after.
 * rom_off is what radeon_read_bios() does when it finds a shadowed ROM, and it
 * may raise a CA error, so the CA error registers are printed around it.
 *
 * Only the ROM enable bit and, with enable_mem=1, Memory Space are ever
 * written, and both are put back.
 */

#include <linux/crc32.h>
#include <linux/debugfs.h>
#include <linux/dma-map-ops.h>
#include <linux/dma-mapping.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/unaligned.h>
#include <linux/vmalloc.h>
#include <asm/sn/addrs.h>
#include <asm/sn/intr.h>
#include <asm/sn/io.h>
#include <asm/sn/pcibus_provider_defs.h>
#include <asm/sn/pcidev.h>
#include <asm/sn/tioca.h>
#include <asm/sn/tioca_provider.h>

#define PROBE_BAR_REGS	2
#define PROBE_BAR_IO	1

extern struct list_head tioca_list;

static bool ca_regs;
module_param(ca_regs, bool, 0444);
MODULE_PARM_DESC(ca_regs, "read the CA registers");
static bool gpu_regs;
module_param(gpu_regs, bool, 0444);
MODULE_PARM_DESC(gpu_regs, "read card registers through BAR2");
static bool io_regs;
module_param(io_regs, bool, 0444);
MODULE_PARM_DESC(io_regs, "read card registers through the I/O BAR");
static bool rom_test;
module_param(rom_test, bool, 0444);
MODULE_PARM_DESC(rom_test, "read the ROM signature with the ROM enabled");
static bool rom_off;
module_param(rom_off, bool, 0444);
MODULE_PARM_DESC(rom_off, "read the ROM signature with the ROM disabled");
static bool rom_dump;
module_param(rom_dump, bool, 0444);
MODULE_PARM_DESC(rom_dump, "copy the ROM to debugfs");
static bool enable_mem;
module_param(enable_mem, bool, 0444);
MODULE_PARM_DESC(enable_mem, "set Memory Space for a step that needs it");

static struct dentry *probe_dir;
static struct debugfs_blob_wrapper rom_blob;

static const struct {
	const char *name;
	u32 reg;
} gpu_reg_list[] = {
	{ "BIOS_0_SCRATCH",	0x0010 },
	{ "CRTC_GEN_CNTL",	0x0050 },
	{ "CONFIG_CNTL",	0x00e0 },
	{ "CONFIG_MEMSIZE",	0x00f8 },
	{ "CONFIG_APER_0_BASE",	0x0100 },
	{ "CONFIG_APER_SIZE",	0x0108 },
	{ "HOST_PATH_CNTL",	0x0130 },
	{ "MC_FB_LOCATION",	0x0148 },
	{ "MC_AGP_LOCATION",	0x014c },
	{ "AGP_BASE",		0x0170 },
	{ "AGP_CNTL",		0x0174 },
	{ "CRTC2_GEN_CNTL",	0x03f8 },
	{ "RBBM_STATUS",	0x0e40 },
	{ "AGP_STATUS",		0x0f5c },
	{ "AGP_COMMAND",	0x0f60 },
};

static u64 ca_read(u64 __iomem *reg)
{
	return __sn_readq_relaxed(reg);
}

static void show_ca_errors(struct tioca_kernel *k, const char *when)
{
	struct tioca __iomem *ca =
		(void __iomem *)k->ca_common->ca_common.bs_base;

	pr_info("CA errors %s: int_status %llx mult %llx first %llx gart_err %llx\n",
		when, ca_read(&ca->ca_int_status), ca_read(&ca->ca_mult_error),
		ca_read(&ca->ca_first_error), ca_read(&ca->ca_gart_err));
	pr_info("CA errors %s: pcierr_type %llx pcierr_addr %llx crm_pkterr %llx\n",
		when, ca_read(&ca->ca_pcierr_type), ca_read(&ca->ca_pcierr_addr),
		ca_read(&ca->ca_crm_pkterr_type));
}

/* Software state only: no register of the CA or the card is read here. */
static void show_ca_soft(struct tioca_kernel *k)
{
	struct pcibus_bussoft *bs = &k->ca_common->ca_common;

	pr_info("CA soft: asic %u xid %u segment %u bus %u base %llx legacy_io %llx legacy_mem %llx\n",
		bs->bs_asic_type, bs->bs_xid, bs->bs_persist_segment,
		bs->bs_persist_busnum, bs->bs_base, bs->bs_legacy_io,
		bs->bs_legacy_mem);
	pr_info("CA soft: rev %u closest nasid %u closest node %d\n",
		k->ca_common->ca_rev, k->ca_common->ca_closest_nasid,
		k->ca_closest_node);
	pr_info("CA soft: aperture %llx size %llx page %u entries %u gart at %llx\n",
		k->ca_ap_bus_base, k->ca_ap_size, k->ca_ap_pagesize,
		k->ca_gart_entries, k->ca_gart_coretalk_addr);
	pr_info("CA soft: pci aperture %llx size %llx, gfx aperture %llx size %llx\n",
		k->ca_pciap_base, k->ca_pciap_size, k->ca_gfxap_base,
		k->ca_gfxap_size);
}

static void show_ca_regs(struct tioca_kernel *k)
{
	struct tioca __iomem *ca =
		(void __iomem *)k->ca_common->ca_common.bs_base;

	pr_info("step ca_regs\n");
	pr_info("CA id %llx control1 %llx control2 %llx status1 %llx status2 %llx\n",
		ca_read(&ca->ca_id), ca_read(&ca->ca_control1),
		ca_read(&ca->ca_control2), ca_read(&ca->ca_status1),
		ca_read(&ca->ca_status2));
	pr_info("CA aperture %llx gart_ptr %llx int_mask %llx pci_extn %llx agp_extn %llx\n",
		ca_read(&ca->ca_gart_aperature), ca_read(&ca->ca_gart_ptr_table),
		ca_read(&ca->ca_int_mask), ca_read(&ca->ca_pci_dma_addr_extn),
		ca_read(&ca->ca_agp_dma_addr_extn));
	pr_info("CA inta_dest %llx intb_dest %llx err_dest %llx\n",
		ca_read(&ca->ca_inta_dest_addr), ca_read(&ca->ca_intb_dest_addr),
		ca_read(&ca->ca_err_int_dest_addr));
	show_ca_errors(k, "now");
}

/* sn_pcidev_info_get(), which SN_PCIDEV_INFO() calls, is not exported. */
static struct pcidev_info *probe_pcidev_info(struct pci_dev *pdev)
{
	struct pcidev_info *info;

	list_for_each_entry(info, &SN_PLATFORM_DATA(pdev->bus)->pcidev_info,
			    pdi_list)
		if (info->pdi_linux_pcidev == pdev)
			return info;
	return NULL;
}

/* Config space and software state: safe on any card, on any bus. */
static void show_card(struct pci_dev *pdev)
{
	struct device *dev = &pdev->dev;
	struct pcidev_info *info = probe_pcidev_info(pdev);
	int cap = pci_find_capability(pdev, PCI_CAP_ID_AGP);
	u32 bar[3], rom, cmd, st = 0, ac = 0;
	int i;

	for (i = 0; i < 3; i++)
		pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0 + i * 4, &bar[i]);
	pci_read_config_dword(pdev, PCI_COMMAND, &cmd);
	pci_read_config_dword(pdev, pdev->rom_base_reg, &rom);
	if (cap) {
		pci_read_config_dword(pdev, cap + PCI_AGP_STATUS, &st);
		pci_read_config_dword(pdev, cap + PCI_AGP_COMMAND, &ac);
	}

	dev_info(dev, "id %04x:%04x sub %04x:%04x class %06x rev %02x irq %d\n",
		 pdev->vendor, pdev->device, pdev->subsystem_vendor,
		 pdev->subsystem_device, pdev->class, pdev->revision, pdev->irq);
	dev_info(dev, "raw BAR0 %08x BAR1 %08x BAR2 %08x ROM %08x COMMAND/STATUS %08x\n",
		 bar[0], bar[1], bar[2], rom, cmd);
	dev_info(dev, "AGP cap at %#x status %08x command %08x (AGP_ENABLE %s)\n",
		 cap, st, ac, ac & PCI_AGP_COMMAND_AGP ? "set" : "clear");
	for (i = 0; i <= PCI_ROM_RESOURCE; i++)
		if (pci_resource_len(pdev, i))
			dev_info(dev, "resource %d %pR\n", i, &pdev->resource[i]);
	if (info)
		for (i = 0; i <= PCI_ROM_RESOURCE; i++)
			if (info->pdi_pio_mapped_addr[i])
				dev_info(dev, "PROM pio addr %d %llx\n", i,
					 info->pdi_pio_mapped_addr[i]);
	dev_info(dev, "numa_node %d bus node %d dma_mask %llx required %llx dma_ops %ps\n",
		 dev_to_node(dev), pcibus_to_node(pdev->bus), dma_get_mask(dev),
		 dma_get_required_mask(dev), get_dma_ops(dev));
}

/* Returns false if the step has to be skipped.  Pair with mem_restore(). */
static bool mem_enable(struct pci_dev *pdev, u16 *saved, const char *step)
{
	pci_read_config_word(pdev, PCI_COMMAND, saved);
	if (*saved & PCI_COMMAND_MEMORY)
		return true;
	if (!enable_mem) {
		dev_warn(&pdev->dev, "%s skipped: Memory Space is off, give enable_mem=1\n",
			 step);
		return false;
	}
	dev_info(&pdev->dev, "%s: setting Memory Space\n", step);
	pci_write_config_word(pdev, PCI_COMMAND, *saved | PCI_COMMAND_MEMORY);
	return true;
}

static void mem_restore(struct pci_dev *pdev, u16 saved)
{
	pci_write_config_word(pdev, PCI_COMMAND, saved);
}

static void show_gpu_regs(struct pci_dev *pdev)
{
	void __iomem *p;
	u16 saved;
	int i;

	dev_info(&pdev->dev, "step gpu_regs\n");
	if (!mem_enable(pdev, &saved, "gpu_regs"))
		return;
	p = ioremap(pci_resource_start(pdev, PROBE_BAR_REGS),
		    pci_resource_len(pdev, PROBE_BAR_REGS));
	if (p) {
		/* readl, as radeon does: this also runs sn_dma_flush() on TIO */
		for (i = 0; i < ARRAY_SIZE(gpu_reg_list); i++)
			dev_info(&pdev->dev, "mmio %-20s %04x = %08x\n",
				 gpu_reg_list[i].name, gpu_reg_list[i].reg,
				 readl(p + gpu_reg_list[i].reg));
		iounmap(p);
	} else {
		dev_err(&pdev->dev, "BAR2 ioremap failed\n");
	}
	mem_restore(pdev, saved);
}

/*
 * The same mapping radeon_device_init() makes for ATOM IIO, so NULL here means
 * radeon will log "Unable to find PCI I/O BAR" and use MMIO instead.
 */
static void show_io_regs(struct pci_dev *pdev)
{
	void __iomem *p;

	dev_info(&pdev->dev, "step io_regs\n");
	if (!(pci_resource_flags(pdev, PROBE_BAR_IO) & IORESOURCE_IO)) {
		dev_warn(&pdev->dev, "BAR1 is not an I/O BAR\n");
		return;
	}
	p = pci_iomap(pdev, PROBE_BAR_IO, pci_resource_len(pdev, PROBE_BAR_IO));
	if (!p) {
		dev_info(&pdev->dev, "pci_iomap(BAR1) returned NULL, radeon falls back to MMIO\n");
		return;
	}
	dev_info(&pdev->dev, "BAR1 mapped at %p\n", p);
	dev_info(&pdev->dev, "io CONFIG_MEMSIZE = %08x\n", ioread32(p + 0xf8));
	pci_iounmap(pdev, p);
}

static void rom_signature(struct pci_dev *pdev, void __iomem *p, const char *when)
{
	u8 a = readb(p), b = readb(p + 1);

	dev_info(&pdev->dev, "ROM %s: %02x %02x (%s)\n", when, a, b,
		 a == 0x55 && b == 0xaa ? "valid signature" : "no signature");
}

static void rom_enable_bit(struct pci_dev *pdev, u32 val)
{
	pci_write_config_dword(pdev, pdev->rom_base_reg, val);
}

static void show_rom(struct pci_dev *pdev, struct tioca_kernel *k, bool enable)
{
	struct resource *rom = &pdev->resource[PCI_ROM_RESOURCE];
	const char *step = enable ? "rom_test" : "rom_off";
	void __iomem *p;
	u32 rb;
	u16 saved;

	dev_info(&pdev->dev, "step %s\n", step);
	if (!rom->start) {
		dev_warn(&pdev->dev, "no ROM resource\n");
		return;
	}
	if (!mem_enable(pdev, &saved, step))
		return;
	pci_read_config_dword(pdev, pdev->rom_base_reg, &rb);
	dev_info(&pdev->dev, "ROM res %pR raw %08x\n", rom, rb);
	show_ca_errors(k, "before");

	p = ioremap(rom->start, 4096);
	if (p) {
		if (enable)
			rom_enable_bit(pdev, rb | PCI_ROM_ADDRESS_ENABLE);
		else
			rom_enable_bit(pdev, rb & ~PCI_ROM_ADDRESS_ENABLE);
		rom_signature(pdev, p, enable ? "enabled" : "disabled");
		rom_enable_bit(pdev, rb);
		iounmap(p);
	} else {
		dev_err(&pdev->dev, "ROM ioremap failed\n");
	}

	show_ca_errors(k, "after");
	mem_restore(pdev, saved);
}

/* Enough of radeon_get_bios() to say whether this image would be accepted. */
static void rom_summary(struct pci_dev *pdev, const u8 *rom, size_t len)
{
	u16 pcir, hdr;

	dev_info(&pdev->dev, "ROM copy: %zu bytes crc32 %08x sig %02x %02x\n", len,
		 crc32_le(~0, rom, len), rom[0], rom[1]);
	if (len < 0x4a || rom[0] != 0x55 || rom[1] != 0xaa)
		return;
	pcir = get_unaligned_le16(rom + 0x18);
	if (pcir + 0x18 <= len && !memcmp(rom + pcir, "PCIR", 4))
		dev_info(&pdev->dev, "ROM PCIR: id %04x:%04x length %u blocks code type %u\n",
			 get_unaligned_le16(rom + pcir + 4),
			 get_unaligned_le16(rom + pcir + 6),
			 get_unaligned_le16(rom + pcir + 0x10), rom[pcir + 0x14]);
	hdr = get_unaligned_le16(rom + 0x48);
	if (hdr + 8 <= len)
		dev_info(&pdev->dev, "ROM header at %#x: %.4s\n", hdr, rom + hdr + 4);
}

static void dump_rom(struct pci_dev *pdev, struct tioca_kernel *k)
{
	struct resource *rom = &pdev->resource[PCI_ROM_RESOURCE];
	size_t i, len = resource_size(rom);
	void __iomem *p;
	u8 *buf;
	u32 rb;
	u16 saved;

	dev_info(&pdev->dev, "step rom_dump\n");
	if (!rom->start || rom_blob.data)
		return;
	if (!mem_enable(pdev, &saved, "rom_dump"))
		return;
	buf = vmalloc(len);
	p = ioremap(rom->start, len);
	if (buf && p) {
		pci_read_config_dword(pdev, pdev->rom_base_reg, &rb);
		rom_enable_bit(pdev, rb | PCI_ROM_ADDRESS_ENABLE);
		for (i = 0; i < len; i++)
			buf[i] = readb(p + i);
		rom_enable_bit(pdev, rb);
		rom_summary(pdev, buf, len);
		show_ca_errors(k, "after dump");
		rom_blob.data = buf;
		rom_blob.size = len;
		buf = NULL;
		debugfs_create_blob("rom", 0400, probe_dir, &rom_blob);
		dev_info(&pdev->dev, "ROM copied to /sys/kernel/debug/prism_probe/rom\n");
	} else {
		dev_err(&pdev->dev, "no memory or mapping for the ROM\n");
	}
	if (p)
		iounmap(p);
	vfree(buf);
	mem_restore(pdev, saved);
}

static void probe_ca(struct tioca_kernel *k)
{
	struct pci_dev *pdev;

	show_ca_soft(k);
	if (ca_regs)
		show_ca_regs(k);

	list_for_each_entry(pdev, k->ca_devices, bus_list) {
		show_card(pdev);
		if (pdev->class != (PCI_CLASS_DISPLAY_VGA << 8))
			continue;
		if (gpu_regs)
			show_gpu_regs(pdev);
		if (io_regs)
			show_io_regs(pdev);
		if (rom_test)
			show_rom(pdev, k, true);
		if (rom_off)
			show_rom(pdev, k, false);
		if (rom_dump)
			dump_rom(pdev, k);
	}
}

static int __init prism_probe_init(void)
{
	struct tioca_kernel *k;

	probe_dir = debugfs_create_dir("prism_probe", NULL);

	if (list_empty(&tioca_list)) {
		struct pci_dev *pdev = NULL;

		pr_info("no CA on this box, config space of its VGA cards only\n");
		while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev)))
			show_card(pdev);
		return 0;
	}

	list_for_each_entry(k, &tioca_list, ca_list)
		probe_ca(k);
	return 0;
}

static void __exit prism_probe_exit(void)
{
	debugfs_remove_recursive(probe_dir);
	vfree(rom_blob.data);
}

module_init(prism_probe_init);
module_exit(prism_probe_exit);

MODULE_DESCRIPTION("Prism TIO CA and card probe");
MODULE_LICENSE("GPL");
