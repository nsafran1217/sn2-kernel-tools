savedcmd_.module-common.o := ia64-linux-gcc -Wp,-MMD,./..module-common.o.d -nostdinc -I/home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include -I/home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated -I/home/nathan/altix_cross/src/mainline/linux-sn2/include -I/home/nathan/altix_cross/src/mainline/linux-sn2/include -I/home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi -I/home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/uapi -I/home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi -I/home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/uapi -include /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler-version.h -include /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kconfig.h -include /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler_types.h -D__KERNEL__ -DHAVE_WORKING_TEXT_ALIGN -DHAVE_MODEL_SMALL_ATTRIBUTE -DHAVE_SERIALIZE_DIRECTIVE -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -pipe -ffixed-r13 -mfixed-range=f12-f15,f32-f127 -frename-registers -fno-optimize-sibling-calls -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fno-stack-protector -fomit-frame-pointer -fno-stack-clash-protection -fno-inline-functions-called-once -fmin-function-alignment=32 -fstrict-flex-arrays=3 -fms-extensions -fno-strict-overflow -fno-stack-check -fconserve-stack -fno-builtin-wcslen -Wall -Wextra -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing-declarations -Wmissing-prototypes -Wframe-larger-than=2048 -Wno-main -Wno-type-limits -Wno-dangling-pointer -Wvla-larger-than=1 -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-stringop-overflow -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wunused -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-truncation -Wno-override-init -Wno-missing-field-initializers -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -Wno-unused-parameter  -DMODULE  -DKBUILD_BASENAME='".module_common"' -DKBUILD_MODNAME='".module_common.o"' -D__KBUILD_MODNAME=.module_common.o -c -o .module-common.o /home/nathan/altix_cross/src/mainline/linux-sn2/scripts/module-common.c  

source_.module-common.o := /home/nathan/altix_cross/src/mainline/linux-sn2/scripts/module-common.c

deps_.module-common.o := \
    $(wildcard include/config/UNWINDER_ORC) \
    $(wildcard include/config/MITIGATION_RETPOLINE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_HAS_SANE_FUNCTION_ALIGNMENT) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/CC_HAS_ASSUME) \
    $(wildcard include/config/CC_HAS_COUNTED_BY) \
    $(wildcard include/config/FORTIFY_SOURCE) \
    $(wildcard include/config/UBSAN_BOUNDS) \
    $(wildcard include/config/CC_HAS_COUNTED_BY_PTR) \
    $(wildcard include/config/CC_HAS_MULTIDIMENSIONAL_NONSTRING) \
    $(wildcard include/config/UBSAN_INTEGER_WRAP) \
    $(wildcard include/config/CFI) \
    $(wildcard include/config/ARCH_USES_CFI_GENERIC_LLVM_PASS) \
    $(wildcard include/config/CC_HAS_BROKEN_COUNTED_BY_REF) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler-context-analysis.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler_attributes.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler-gcc.h \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
    $(wildcard include/config/CC_HAS_TYPEOF_UNQUAL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/module.h \
    $(wildcard include/config/MODULES) \
    $(wildcard include/config/SYSFS) \
    $(wildcard include/config/MODULES_TREE_LOOKUP) \
    $(wildcard include/config/LIVEPATCH) \
    $(wildcard include/config/STACKTRACE_BUILD_ID) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/MODULE_SIG) \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/KALLSYMS) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/TRACEPOINTS) \
    $(wildcard include/config/TREE_SRCU) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/DEBUG_INFO_BTF_MODULES) \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/DYNAMIC_FTRACE) \
    $(wildcard include/config/KPROBES) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
    $(wildcard include/config/KUNIT) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/MODULE_UNLOAD) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/container_of.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/build_bug.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/asm/rwonce.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/rwonce.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/int-ll64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/int-ll64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/bitsperlong.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitsperlong.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/bitsperlong.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/posix_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/stddef.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/stddef.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/posix_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/posix_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/const.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/const.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/const.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/barrier.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/barrier.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/stat.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/stat.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/stat.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/time.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/kernel.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/sysinfo.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/cache.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/cache.h \
    $(wildcard include/config/IA64_L1_CACHE_SHIFT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/math.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/div64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/div64.h \
    $(wildcard include/config/CC_OPTIMIZE_FOR_PERFORMANCE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/math64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/time64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/time64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/time.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/time_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/time32.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/timex.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/timex.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/param.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/param.h \
    $(wildcard include/config/HZ) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/param.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/timex.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/intrinsics.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/intrinsics.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/ia64regs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/gcc_intrin.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/gcc_intrin.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/cmpxchg.h \
    $(wildcard include/config/IA64_DEBUG_CMPXCHG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/cmpxchg.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/processor.h \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/ITANIUM) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/kregs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/ptrace.h \
    $(wildcard include/config/IA64_PAGE_SIZE_4KB) \
    $(wildcard include/config/IA64_PAGE_SIZE_8KB) \
    $(wildcard include/config/IA64_PAGE_SIZE_16KB) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/asm-offsets.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/asm-offsets.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/ptrace.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/fpu.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/current.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/page.h \
    $(wildcard include/config/PAGE_SHIFT) \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/PGTABLE_LEVELS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
    $(wildcard include/config/SPARSEMEM) \
    $(wildcard include/config/DEBUG_VIRTUAL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/pfn.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/getorder.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bitops.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/bits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/bits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/overflow.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/limits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/limits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/limits.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/typecheck.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/generic-non-atomic.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/bitops.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/fls64.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/builtin-ffs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/const_hweight.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/non-instrumented-non-atomic.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/lock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/atomic.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/atomic.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/atomic/atomic-long.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/atomic/atomic-instrumented.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/instrumented.h \
    $(wildcard include/config/DEBUG_ATOMIC) \
    $(wildcard include/config/DEBUG_ATOMIC_LARGEST_ALIGN) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bug.h \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/bug.h \
    $(wildcard include/config/BUG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE_DETAILED) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/instrumentation.h \
    $(wildcard include/config/NOINSTR_VALIDATION) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/once_lite.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/stdarg.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/init.h \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/stringify.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kern_levels.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/GENDWARFKSYMS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/linkage.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/ratelimit_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/spinlock_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/LOCK_STAT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/dynamic_debug.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kmsan-checks.h \
    $(wildcard include/config/KMSAN) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/instrumented-lock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/le.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/byteorder.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/byteorder/little_endian.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/byteorder/little_endian.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/swab.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/swab.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/swab.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/byteorder/generic.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/bitops/sched.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/ustack.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/ustack.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/threads.h \
    $(wildcard include/config/NR_CPUS) \
    $(wildcard include/config/BASE_SMALL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/percpu.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/percpu.h \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/percpu-defs.h \
    $(wildcard include/config/ARCH_MODULE_NEEDS_WEAK_PER_CPU) \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/rse.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/unwind.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/nodedata.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/numa.h \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/nodemask.h \
    $(wildcard include/config/HIGHMEM) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bitmap.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/align.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/align.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/cleanup.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/err.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/uapi/asm/errno.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/errno.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/errno-base.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/args.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/errno.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/errno.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/find.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/array_size.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/string.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/string.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bitmap-str.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/minmax.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/nodemask_types.h \
    $(wildcard include/config/NODES_SHIFT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/random.h \
    $(wildcard include/config/VMGENID) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kstrtox.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sprintf.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/trace_printk.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/instruction_pointer.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/util_macros.h \
    $(wildcard include/config/FOO_SUSPEND) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/wordpart.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/random.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/ioctl.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/uapi/asm/ioctl.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/ioctl.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/ioctl.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/irqnr.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/irqnr.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/sparsemem.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/mmzone.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/meminit.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/time32.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/time.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/uidgid.h \
    $(wildcard include/config/MULTIUSER) \
    $(wildcard include/config/USER_NS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/uidgid_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/highuid.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/buildid.h \
    $(wildcard include/config/VMCORE_INFO) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kmod.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/umh.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/gfp.h \
    $(wildcard include/config/ZONE_DMA) \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mmzone.h \
    $(wildcard include/config/PAGE_BLOCK_MAX_ORDER) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/IOMMU_SUPPORT) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/NUMA_BALANCING) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/LRU_GEN) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/LRU_GEN_WALKS_MMU) \
    $(wildcard include/config/MEMCG) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP_PREINIT) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/spinlock.h \
    $(wildcard include/config/PREEMPTION) \
    $(wildcard include/config/PREEMPT_RT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/PREEMPT) \
    $(wildcard include/config/PREEMPT_LAZY) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/asm/preempt.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/preempt.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/thread_info.h \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/GENERIC_ENTRY) \
    $(wildcard include/config/ARCH_HAS_PREEMPT_LAZY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/SH) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/restart_block.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/thread_info.h \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_NATIVE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/irqflags.h \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/irqflags_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/irqflags.h \
    $(wildcard include/config/IA64_DEBUG_IRQ) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/pal.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/bottom_half.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/lockdep.h \
    $(wildcard include/config/DEBUG_LOCKING_API_SELFTESTS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
    $(wildcard include/config/CSD_LOCK_WAIT_DEBUG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/cpumask_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/smp_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/smp.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/irqreturn.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/mmiowb.h \
    $(wildcard include/config/IA64_SGI_SN2) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/mmiowb.h \
    $(wildcard include/config/MMIOWB) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/spinlock_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rwlock_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/spinlock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rwlock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/INLINE_SPIN_LOCK) \
    $(wildcard include/config/INLINE_SPIN_LOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK_BH) \
    $(wildcard include/config/UNINLINE_SPIN_UNLOCK) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/GENERIC_LOCKBREAK) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/INLINE_READ_LOCK) \
    $(wildcard include/config/INLINE_WRITE_LOCK) \
    $(wildcard include/config/INLINE_READ_LOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_LOCK_BH) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_READ_TRYLOCK) \
    $(wildcard include/config/INLINE_WRITE_TRYLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_BH) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQRESTORE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/list_nulls.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/wait.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/seqlock.h \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/GCC_VERSION) \
    $(wildcard include/config/KASAN) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mutex.h \
    $(wildcard include/config/DEBUG_MUTEXES) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/osq_lock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/debug_locks.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mutex_types.h \
    $(wildcard include/config/MUTEX_SPIN_ON_OWNER) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/seqlock_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/page-flags-layout.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/bounds.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/SLAB_OBJ_EXT) \
    $(wildcard include/config/HUGETLB_PMD_PAGE_TABLE_SHARING) \
    $(wildcard include/config/SLAB_FREELIST_HARDENED) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/FUTEX_PRIVATE_HASH) \
    $(wildcard include/config/ARCH_HAS_ELF_CORE_EFLAGS) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/SPLIT_PMD_PTLOCKS) \
    $(wildcard include/config/ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH) \
    $(wildcard include/config/IOMMU_MM_DATA) \
    $(wildcard include/config/KSM) \
    $(wildcard include/config/MM_ID) \
    $(wildcard include/config/SCHED_MM_CID) \
    $(wildcard include/config/CORE_DUMP_DEFAULT_ELF_HEADERS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mm_types_task.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/auxvec.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/auxvec.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/auxvec.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kref.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/refcount.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/refcount_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rbtree.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rbtree_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rcupdate.h \
    $(wildcard include/config/PREEMPT_RCU) \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/NO_HZ_FULL) \
    $(wildcard include/config/VIRT_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/TASKS_RCU) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched.h \
    $(wildcard include/config/SCHED_INFO) \
    $(wildcard include/config/SCHEDSTATS) \
    $(wildcard include/config/SCHED_CORE) \
    $(wildcard include/config/FAIR_GROUP_SCHED) \
    $(wildcard include/config/RT_GROUP_SCHED) \
    $(wildcard include/config/RT_MUTEXES) \
    $(wildcard include/config/UCLAMP_TASK) \
    $(wildcard include/config/UCLAMP_BUCKETS_COUNT) \
    $(wildcard include/config/KMAP_LOCAL) \
    $(wildcard include/config/MEM_ALLOC_PROFILING) \
    $(wildcard include/config/SCHED_CLASS_EXT) \
    $(wildcard include/config/CGROUP_SCHED) \
    $(wildcard include/config/CFS_BANDWIDTH) \
    $(wildcard include/config/BLK_DEV_IO_TRACE) \
    $(wildcard include/config/TASKS_TRACE_RCU) \
    $(wildcard include/config/MEMCG_V1) \
    $(wildcard include/config/COMPAT_BRK) \
    $(wildcard include/config/CGROUPS) \
    $(wildcard include/config/BLK_CGROUP) \
    $(wildcard include/config/PSI) \
    $(wildcard include/config/PAGE_OWNER) \
    $(wildcard include/config/EVENTFD) \
    $(wildcard include/config/ARCH_HAS_CPU_PASID) \
    $(wildcard include/config/X86_BUS_LOCK_DETECT) \
    $(wildcard include/config/TASK_DELAY_ACCT) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/ARCH_HAS_SCALED_CPUTIME) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_GEN) \
    $(wildcard include/config/POSIX_CPUTIMERS) \
    $(wildcard include/config/POSIX_CPU_TIMERS_TASK_WORK) \
    $(wildcard include/config/KEYS) \
    $(wildcard include/config/SYSVIPC) \
    $(wildcard include/config/DETECT_HUNG_TASK) \
    $(wildcard include/config/IO_URING) \
    $(wildcard include/config/AUDIT) \
    $(wildcard include/config/AUDITSYSCALL) \
    $(wildcard include/config/DETECT_HUNG_TASK_BLOCKER) \
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/COMPAT) \
    $(wildcard include/config/PERF_EVENTS) \
    $(wildcard include/config/ARCH_HAS_LAZY_MMU_MODE) \
    $(wildcard include/config/FAULT_INJECTION) \
    $(wildcard include/config/LATENCYTOP) \
    $(wildcard include/config/FUNCTION_GRAPH_TRACER) \
    $(wildcard include/config/UPROBES) \
    $(wildcard include/config/BCACHE) \
    $(wildcard include/config/VMAP_STACK) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/BPF_SYSCALL) \
    $(wildcard include/config/KSTACK_ERASE) \
    $(wildcard include/config/KSTACK_ERASE_METRICS) \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KRETPROBES) \
    $(wildcard include/config/RETHOOK) \
    $(wildcard include/config/ARCH_HAS_PARANOID_L1D_FLUSH) \
    $(wildcard include/config/RV) \
    $(wildcard include/config/RV_PER_TASK_MONITORS) \
    $(wildcard include/config/USER_EVENTS) \
    $(wildcard include/config/UNWIND_USER) \
    $(wildcard include/config/SCHED_PROXY_EXEC) \
    $(wildcard include/config/ARCH_TASK_STRUCT_ON_STACK) \
    $(wildcard include/config/MEM_ALLOC_PROFILING_DEBUG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/sched.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/pid_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sem_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/shm.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/shmparam.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kmsan_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/plist_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/hrtimer_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/timerqueue_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/timer_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/seccomp_types.h \
    $(wildcard include/config/SECCOMP) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/resource.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/resource.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/resource.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/resource.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/resource.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/latencytop.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched/prio.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched/types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/signal_types.h \
    $(wildcard include/config/OLD_SIGACTION) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/signal.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/signal.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/signal.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/signal-defs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/sigcontext.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/uapi/asm/siginfo.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/asm-generic/siginfo.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/syscall_user_dispatch_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/netdevice_xmit.h \
    $(wildcard include/config/NET_ACT_MIRRED) \
    $(wildcard include/config/NET_EGRESS) \
    $(wildcard include/config/NF_DUP_NETDEV) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/task_io_accounting.h \
    $(wildcard include/config/TASK_IO_ACCOUNTING) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/posix-timers_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rseq_types.h \
    $(wildcard include/config/RSEQ) \
    $(wildcard include/config/RSEQ_SLICE_EXTENSION) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/irq_work_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/workqueue_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kcsan.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rv.h \
    $(wildcard include/config/RV_LTL_MONITOR) \
    $(wildcard include/config/RV_REACTORS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/tracepoint-defs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/static_key.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/jump_label.h \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/unwind_deferred_types.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/generated/asm/kmap_size.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/kmap_size.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/rq-offsets.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched/ext.h \
    $(wildcard include/config/EXT_GROUP_SCHED) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rcutree.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/completion.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/swait.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/uprobes.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
    $(wildcard include/config/NO_HZ_COMMON) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/ktime.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/jiffies.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/jiffies.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/timeconst.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/vdso/ktime.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/timekeeping.h \
    $(wildcard include/config/POSIX_AUX_CLOCKS) \
    $(wildcard include/config/GENERIC_CMOS_UPDATE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/clocksource_ids.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/debugobjects.h \
    $(wildcard include/config/DEBUG_OBJECTS) \
    $(wildcard include/config/DEBUG_OBJECTS_FREE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/workqueue.h \
    $(wildcard include/config/DEBUG_OBJECTS_WORK) \
    $(wildcard include/config/FREEZER) \
    $(wildcard include/config/WQ_WATCHDOG) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/alloc_tag.h \
    $(wildcard include/config/MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/codetag.h \
    $(wildcard include/config/CODE_TAGGING) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/percpu_counter.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/percpu.h \
    $(wildcard include/config/RANDOM_KMALLOC_CACHES) \
    $(wildcard include/config/PAGE_SIZE_4KB) \
    $(wildcard include/config/NEED_PER_CPU_PAGE_FIRST_CHUNK) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/mmdebug.h \
    $(wildcard include/config/DEBUG_VM) \
    $(wildcard include/config/DEBUG_VM_IRQSOFF) \
    $(wildcard include/config/DEBUG_VM_PGFLAGS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/mmu.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/page-flags.h \
    $(wildcard include/config/PAGE_IDLE_FLAG) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_2) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_3) \
    $(wildcard include/config/MIGRATION) \
    $(wildcard include/config/HUGETLB_PAGE_OPTIMIZE_VMEMMAP) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/local_lock.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/local_lock_internal.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/zswap.h \
    $(wildcard include/config/ZSWAP) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/memory_hotplug.h \
    $(wildcard include/config/ARCH_HAS_ADD_PAGES) \
    $(wildcard include/config/MEMORY_HOTREMOVE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/notifier.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rcu_segcblist.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/srcutree.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/topology.h \
    $(wildcard include/config/USE_PERCPU_NUMA_NODE_ID) \
    $(wildcard include/config/SCHED_SMT) \
    $(wildcard include/config/GENERIC_ARCH_TOPOLOGY) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/arch_topology.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/topology.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/acpi.h \
    $(wildcard include/config/ACPI_HOTPLUG_CPU) \
    $(wildcard include/config/ACPI_NUMA) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/acpi/proc_cap_intel.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/numa.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/topology.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sysctl.h \
    $(wildcard include/config/SYSCTL) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/sysctl.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/elf.h \
    $(wildcard include/config/ARCH_HAVE_EXTRA_ELF_NOTES) \
    $(wildcard include/config/ARCH_USE_GNU_PROPERTY) \
    $(wildcard include/config/ARCH_HAVE_ELF_PROT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/elf.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/elf.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/uapi/linux/elf-em.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kobject.h \
    $(wildcard include/config/UEVENT_HELPER) \
    $(wildcard include/config/DEBUG_KOBJECT_RELEASE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sysfs.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kernfs.h \
    $(wildcard include/config/KERNFS) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/idr.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/radix-tree.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/xarray.h \
    $(wildcard include/config/XARRAY_MULTI) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched/mm.h \
    $(wildcard include/config/MMU_LAZY_TLB_REFCOUNT) \
    $(wildcard include/config/ARCH_HAS_MEMBARRIER_CALLBACKS) \
    $(wildcard include/config/ARCH_HAS_SYNC_CORE_BEFORE_USERMODE) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sync_core.h \
    $(wildcard include/config/ARCH_HAS_PREPARE_SYNC_CORE_CMD) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/sched/coredump.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/kobject_ns.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/moduleparam.h \
    $(wildcard include/config/ALPHA) \
    $(wildcard include/config/IA64) \
    $(wildcard include/config/PPC64) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/rbtree_latch.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/error-injection.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/error-injection.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/module.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/asm-generic/module.h \
    $(wildcard include/config/HAVE_MOD_ARCH_SPECIFIC) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/build-salt.h \
    $(wildcard include/config/BUILD_SALT) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/elfnote.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/elfnote-lto.h \
    $(wildcard include/config/LTO) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/linux/vermagic.h \
    $(wildcard include/config/PREEMPT_BUILD) \
  /home/nathan/altix_cross/src/mainline/linux-sn2/include/generated/utsrelease.h \
  /home/nathan/altix_cross/src/mainline/linux-sn2/arch/ia64/include/asm/vermagic.h \

.module-common.o: $(deps_.module-common.o)

$(deps_.module-common.o):
