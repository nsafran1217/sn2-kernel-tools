Lets work on re-adding SN2 support to linux 6.6. I have uploaded `6.6-clean.tar.xz` to this chat which contains the files that we need to patch. I also uploaded `6.1-sn2-patched.tar.xz` which is the patched version which works on SN2.

PLAN.md was the original document describing the changes required to bring SN2 back into the kernel. Read it first to understand the theory of what we are doing. Update the document if needed.

Apply the patches from `sn2-v6.1-complete.patch` that is in the project.  
There will be issues when applying the patch. After fixing and applying the patch to the clean tree, examine the resulting files for build issues.  
Changes should be applied to SN2 specific files.  

Reference the previous chats named "Re-adding SN2 support to Linux 6.1, "Re-adding SN2 support to Linux 5.10", "Re-adding SN2 support to Linux 5.15" and "Re-adding SN2 support to Linux kernel 5.4" for context. They are located in this project.  

Document the changes required in fixes.md file. 
Create a new patch with the changes required for 6.6. Confirm that the patch applies cleanly.






Gen context:

tar cJf ~/desktop/VERSION.tar.xz \
  --exclude='*.o' \
  --exclude='*.o.*' \
  --exclude='*.a' \
  --exclude='*.ko' \
  --exclude='.*.cmd' \
  --exclude='*.bin' \
  --exclude='*.gz' \
  arch/ia64 \
  drivers/Kconfig \
  drivers/Makefile \
  drivers/acpi/Kconfig \
  drivers/char/Kconfig \
  drivers/char/Makefile \
  drivers/char/mspec.c \
  drivers/char/agp/Kconfig \
  drivers/char/agp/Makefile \
  drivers/ide/Kconfig \
  drivers/ide/Makefile \
  drivers/iommu/Kconfig \
  drivers/misc/Kconfig \
  drivers/misc/Makefile \
  drivers/misc/sgi-xp/ \
  drivers/pci/hotplug/Kconfig \
  drivers/pci/hotplug/Makefile \
  drivers/scsi/qla1280.c \
  drivers/scsi/qla1280.h \
  drivers/scsi/qla2xxx/qla_init.c \
  drivers/sn/ \
  drivers/tty/serial/Kconfig \
  drivers/tty/serial/Makefile \
  drivers/tty/serial/sn_console.c \
  include/linux/pci_ids.h \
  kernel/fork.c \
  kernel/irq/proc.c




# Build issues:

Okay, lets work on fixing the build issues. Keep track of the build issues in a file.  
Give me individual patches, at the end, we'll combine them into the complete patch.  

first build issue:

# After patch is done
This is working well. Built and Boot successfully.. Please add those build patches into the complete patch.  
Please create individual patch files in this format, similar to what was done in the chat `Re-adding SN2 support to Linux 5.10`  
* 0001 - Drop-in: SN2 platform, headers, drivers, misc
* 0002 - machvec: minimal compatibility shim
* 0003 - kconfig: add SN2 platform config and build rules
* 0004 - ia64: add SN2 hooks to core code via ifdef
* 0005 - drivers: add SN2 driver Kconfig and Makefile entries
* 0006 - drivers: add SN2 support to mspec, qla1280, qla2xxx

# Or if you just want one big patch
This is working well. Built and Boot successfully. Please add those build patches into the complete patch. Confirm that the patch applies cleanly to the source tree