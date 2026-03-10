# SN2 v6.1 Build Issues

## Issue 1: `arch/ia64/sn/kernel/msi_sn.c` — two errors

**Patch:** `0001-ia64-sn2-fix-msi_sn-build-errors-for-6.1.patch`

### Error 1a: `struct msi_desc` has no member `msi_attrib`

```
arch/ia64/sn/kernel/msi_sn.c:78:19: error: 'struct msi_desc' has no member named 'msi_attrib'
   78 |         if (!entry->msi_attrib.is_64)
```

**Cause:** In v5.17 (commit `645474e2e07d`, "genirq/msi: Rework MSI descriptor data"),
`struct msi_desc` was reorganized. The PCI-specific `msi_attrib` sub-struct was moved
into a `pci` union member: `entry->msi_attrib` → `entry->pci.msi_attrib`.

**Fix:** `entry->msi_attrib.is_64` → `entry->pci.msi_attrib.is_64`

### Error 1b: `irq_data_get_affinity_mask()` returns `const` pointer

```
arch/ia64/sn/kernel/msi_sn.c:209:22: warning: passing argument 1 of 'cpumask_copy'
    discards 'const' qualifier from pointer target type
```

**Cause:** In v5.17 (commit `4d60e8e3a7a3`, "genirq: Return a const cpumask from
irq_data_get_affinity_mask"), the return type changed to `const struct cpumask *`.
Writing through it with `cpumask_copy()` as the destination is invalid.

**Fix:** Replace `cpumask_copy(irq_data_get_affinity_mask(data), cpu_mask)` with
`irq_data_update_affinity(data, cpu_mask)`. This matches what `msi_ia64.c` already
uses in the same 6.1 kernel (line 40).

---

## Issue 2: `drivers/tty/serial/ioc4_serial.c` — three errors

**Patch:** `0002-serial-ioc4_serial-fix-build-errors-for-6.1.patch`

### Error 2a: `pci_alloc_consistent` / `pci_free_consistent` implicit declaration

```
drivers/tty/serial/ioc4_serial.c:1148:56: error: implicit declaration of function 'pci_alloc_consistent'
drivers/tty/serial/ioc4_serial.c:2675:25: error: implicit declaration of function 'pci_free_consistent'
```

**Cause:** In v5.18 (commit `4167b2b68b69`, "PCI: Remove pci_alloc/free_consistent wrappers"),
these legacy PCI DMA wrappers were removed. They were thin wrappers around
`dma_alloc_coherent` / `dma_free_coherent`.

**Fix:**
- `pci_alloc_consistent(pdev, size, &dma)` → `dma_alloc_coherent(&pdev->dev, size, &dma, GFP_KERNEL)`
- `pci_free_consistent(pdev, size, va, dma)` → `dma_free_coherent(&pdev->dev, size, va, dma)`

Note: first argument changes from `struct pci_dev *` to `&pci_dev->dev`, and
`dma_alloc_coherent` requires explicit GFP flags.

### Error 2b: `struct uart_port` has no member `timeout`

```
drivers/tty/serial/ioc4_serial.c:1741:17: error: 'struct uart_port' has no member named 'timeout'
drivers/tty/serial/ioc4_serial.c:1742:17: error: 'struct uart_port' has no member named 'timeout'
```

**Cause:** In v6.1 (commit `deae1069743e`, "serial: Remove uart_port::timeout"), the
`timeout` field was removed. The serial core now computes port timeouts internally.

**Fix:** Remove the two timeout assignment lines:
```c
the_port->timeout = ((the_port->fifosize * HZ * bits) / (baud / 10));
the_port->timeout += HZ / 50;
```

### Warning 2c: unused variable `state`

```
drivers/tty/serial/ioc4_serial.c:1693:28: warning: unused variable 'state'
```

**Cause:** With the timeout lines removed, `state` is no longer referenced in
`ioc4_change_speed()`.

**Fix:** Remove the `struct uart_state *state = the_port->state;` declaration.
