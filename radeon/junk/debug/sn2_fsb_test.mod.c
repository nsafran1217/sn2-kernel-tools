#include <linux/module.h>
#include <linux/export-internal.h>
#include <linux/compiler.h>

MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};



static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0xd634d33c, "_printk" },
	{ 0x6a5cc518, "__kmalloc_noprof" },
	{ 0x4778916e, "alloc_pages_noprof" },
	{ 0x037a0cba, "kfree" },
	{ 0x12b48d56, "__free_pages" },
	{ 0xb43f9365, "ktime_get" },
	{ 0x9073fec9, "__moddi3" },
	{ 0xa39b4cf2, "udelay" },
	{ 0xc0bf69d3, "__divdi3" },
	{ 0x6df43eeb, "param_ops_int" },
	{ 0xd8b453d1, "module_layout" },
};

MODULE_INFO(depends, "");


MODULE_INFO(srcversion, "9D83C76308AC8393EC5F966");
