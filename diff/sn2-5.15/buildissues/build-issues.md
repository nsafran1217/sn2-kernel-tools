# SN2 v5.15 Build Issues

Tracking file for build issues found when compiling Linux 5.15 with
`CONFIG_IA64_SGI_SN2=y`.

All fixes are folded into the split patch set (0001-0006) and the
combined `sn2-v5.15-complete.patch`.

---

## fix-0001: ZONE_DMA32 undeclared in paging_init()

**Error:**
```
arch/ia64/mm/discontig.c:604:23: error: 'ZONE_DMA32' undeclared
  604 |         max_zone_pfns[ZONE_DMA32] = max_dma;
```

**Cause:** SN2 disables `ZONE_DMA32` (via `select ZONE_DMA32 if !IA64_SGI_SN2`
in Kconfig) because SN2 uses its own DMA handling through SHUB.  But
`paging_init()` in both `discontig.c` and `contig.c` unconditionally
references `ZONE_DMA32`.

**Fix:** Guard the `ZONE_DMA32` array assignment with `#ifdef CONFIG_ZONE_DMA32`.
Fold `max_dma` variable into the guarded block to avoid unused variable warning.

**Files:** `arch/ia64/mm/discontig.c`, `arch/ia64/mm/contig.c`

**Folded into:** `0004` (core ia64 ifdef hooks)

---

## fix-0002: tiocx.c bus_type.remove signature and MODULE_SUPPORTED_DEVICE

**Error:**
```
arch/ia64/sn/kernel/tiocx.c:150:19: error: initialization of 'void (*)(struct device *)'
  from incompatible pointer type 'int (*)(struct device *)' [-Werror=incompatible-pointer-types]
arch/ia64/sn/kernel/tiocx.c:570:25: error: expected declaration specifiers or '...'
  before string constant
  570 | MODULE_SUPPORTED_DEVICE(DEVICE_NAME);
```

**Cause:** Two upstream API changes:
1. `bus_type.remove` changed from `int (*)(struct device *)` to
   `void (*)(struct device *)` in v5.15 (commit `fc7a6209d571`).
2. `MODULE_SUPPORTED_DEVICE()` macro removed in v5.12
   (commit `1d6272f3a455`).

**Fix:** Change `cx_driver_remove()` return type from `int` to `void`,
remove the `return 0`.  Delete the `MODULE_SUPPORTED_DEVICE()` call.

**Files:** `arch/ia64/sn/kernel/tiocx.c`

**Folded into:** `0001` (drop-in SN2 platform files)

---

## fix-0003: Drop IOC3 driver entirely

**Error:**
```
drivers/tty/serial/ioc3_serial.c:1000:20: error: 'struct tty_port' has no member named 'low_latency'
 1000 |         state->port.low_latency = 1;
```

**Cause:** `tty_port.low_latency` was removed in v5.12 (commit `b3b576461c47`).

**Fix:** Rather than patching the IOC3 driver, drop it entirely.  IOC3 is
not used on SN2 systems - only IOC4 is present.  The IOC4 base driver
(`drivers/misc/ioc4.c`) and IOC4 serial driver
(`drivers/tty/serial/ioc4_serial.c`) are retained.

**Files removed:**
- `include/linux/ioc3.h`
- `arch/ia64/include/asm/sn/ioc3.h`
- `drivers/sn/ioc3.c`
- `drivers/tty/serial/ioc3_serial.c`

**Files modified:**
- `drivers/sn/Kconfig` - remove `SGI_IOC3` config
- `drivers/sn/Makefile` - remove `ioc3.o` build
- `drivers/tty/serial/Kconfig` - remove `SERIAL_SGI_IOC3` config
- `drivers/tty/serial/Makefile` - remove `ioc3_serial.o` build

**Folded into:** `0001` (Kconfig/Makefile in 0005, source removals in 0001)

---

## fix-0004: ioc4_serial.c tty_port.low_latency removed

**Error:**
```
drivers/tty/serial/ioc4_serial.c:1746:20: error: 'struct tty_port' has no member named 'low_latency'
 1746 |         state->port.low_latency = 1;
```

**Cause:** Same API change as IOC3 - `tty_port.low_latency` removed in
v5.12 (commit `b3b576461c47`).  All tty ports are now low latency by
default, so the assignment is unnecessary.

**Fix:** Remove the `state->port.low_latency = 1` line.

**Files:** `drivers/tty/serial/ioc4_serial.c`

**Folded into:** `0001` (drop-in SN2 platform files)
