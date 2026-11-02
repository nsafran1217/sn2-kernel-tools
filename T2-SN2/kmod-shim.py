#!/usr/bin/env python3
# kmod-shim.py: just enough of Linux kmod's `modinfo` and `depmod` for T2's
# mkinitrd to run on macOS. Symlink it as `modinfo` and `depmod`; it picks
# its personality from the name it was called by.
#
# modinfo  : reads the .modinfo ELF section of a module file (.ko, .ko.zst,
#            .ko.xz, .ko.gz). Supports `-F field` (other flags are ignored).
#
# depmod   : does not resolve symbols itself. Instead it takes the module
#            index text files made by the real depmod when the kernel was
#            built (the "reference" tree), keeps only the modules present in
#            the target tree, and writes fresh text + .bin index files in the
#            exact kmod format. The reference module directory comes from
#            $KMOD_SHIM_REF_MODDIR, or else <root>/lib/modules/<ver> where
#            <root> is derived from `-F <root>/boot/System.map-<ver>`.

import gzip
import lzma
import os
import struct
import subprocess
import sys

COMPRESS_EXTS = (".zst", ".xz", ".gz")


def die(msg, code=1):
    sys.stderr.write("%s: %s\n" % (os.path.basename(sys.argv[0]), msg))
    sys.exit(code)


def strip_compress_ext(path):
    for ext in COMPRESS_EXTS:
        if path.endswith(ext):
            return path[: -len(ext)]
    return path


def path_to_modname(path):
    # kmod: basename, '-' -> '_', cut at first '.'
    return os.path.basename(path).split(".", 1)[0].replace("-", "_")


def underscores(s):
    # kmod: '-' -> '_' except inside [...] glob brackets
    out, i = [], 0
    while i < len(s):
        c = s[i]
        if c == "[":
            j = s.find("]", i)
            j = len(s) if j < 0 else j + 1
            out.append(s[i:j])
            i = j
            continue
        out.append("_" if c == "-" else c)
        i += 1
    return "".join(out)


# ── modinfo ──────────────────────────────────────────────────────────────────

def read_module(path):
    if path.endswith(".zst"):
        return subprocess.run(["zstd", "-dcq", path], check=True,
                              stdout=subprocess.PIPE).stdout
    if path.endswith(".xz"):
        with lzma.open(path) as f:
            return f.read()
    if path.endswith(".gz"):
        with gzip.open(path) as f:
            return f.read()
    with open(path, "rb") as f:
        return f.read()


def elf_section(data, wanted):
    if data[:4] != b"\x7fELF":
        raise ValueError("not an ELF file")
    is64 = data[4] == 2
    end = "<" if data[5] == 1 else ">"
    if is64:
        shoff, = struct.unpack_from(end + "Q", data, 0x28)
        shentsize, shnum, shstrndx = struct.unpack_from(end + "HHH", data, 0x3A)
        shfmt = end + "IIQQQQIIQQ"
    else:
        shoff, = struct.unpack_from(end + "I", data, 0x20)
        shentsize, shnum, shstrndx = struct.unpack_from(end + "HHH", data, 0x2E)
        shfmt = end + "IIIIIIIIII"
    secs = [struct.unpack_from(shfmt, data, shoff + i * shentsize) for i in range(shnum)]
    stroff, strsize = secs[shstrndx][4], secs[shstrndx][5]
    names = data[stroff:stroff + strsize]
    for s in secs:
        name = names[s[0]:names.index(b"\0", s[0])].decode()
        if name == wanted:
            return data[s[4]:s[4] + s[5]]
    return b""


def modinfo_fields(path):
    sec = elf_section(read_module(path), ".modinfo")
    for entry in sec.split(b"\0"):
        if b"=" in entry:
            k, v = entry.split(b"=", 1)
            yield k.decode(), v.decode(errors="replace")


def main_modinfo(argv):
    field, files, i = None, [], 0
    while i < len(argv):
        a = argv[i]
        if a in ("-F", "--field"):
            field = argv[i + 1]; i += 2; continue
        if a.startswith("--field="):
            field = a.split("=", 1)[1]; i += 1; continue
        if a in ("-b", "--basedir", "-k", "--set-version"):
            i += 2; continue
        if a.startswith("-"):
            i += 1; continue
        files.append(a); i += 1
    if not files:
        die("no module given")
    rc = 0
    for f in files:
        if not os.path.isfile(f):
            sys.stderr.write("modinfo: ERROR: Module %s not found.\n" % f)
            rc = 1
            continue
        for k, v in modinfo_fields(f):
            if field is None:
                print("%-16s%s" % (k + ":", v))
            elif k == field:
                print(v)
    return rc


# ── kmod index (.bin) writer: mirrors kmod tools/depmod.c ────────────────────

INDEX_MAGIC = 0xB007F457
INDEX_VERSION = (0x0002 << 16) | 0x0001
INDEX_CHILDMAX = 128
NODE_PREFIX, NODE_VALUES, NODE_CHILDS = 0x80000000, 0x40000000, 0x20000000


class Node:
    __slots__ = ("prefix", "children", "first", "last", "values")

    def __init__(self, prefix=""):
        self.prefix = prefix
        self.children = {}
        self.first = INDEX_CHILDMAX
        self.last = 0
        self.values = []  # list of (priority, value), kept in kmod order

    def add_value(self, value, priority):
        # kmod reports duplicate values but still stores them
        pos = 0
        while pos < len(self.values) and self.values[pos][0] < priority:
            pos += 1
        self.values.insert(pos, (priority, value))


def index_insert(node, key, value, priority):
    i = 0
    while True:
        j = 0
        while j < len(node.prefix):
            ch = node.prefix[j]
            if i + j >= len(key) or key[i + j] != ch:
                n = Node(node.prefix[j + 1:])
                n.children, n.first, n.last, n.values = (
                    node.children, node.first, node.last, node.values)
                node.prefix = node.prefix[:j]
                node.children = {ord(ch): n}
                node.first = node.last = ord(ch)
                node.values = []
                break
            j += 1
        i += j
        if i >= len(key):
            node.add_value(value, priority)
            return
        ch = ord(key[i])
        if ch >= INDEX_CHILDMAX:
            raise ValueError("non-ASCII key %r" % key)
        child = node.children.get(ch)
        if child is None:
            node.first = min(node.first, ch)
            node.last = max(node.last, ch)
            child = Node(key[i + 1:])
            child.add_value(value, priority)
            node.children[ch] = child
            return
        node = child
        i += 1


def index_write(root, path):
    buf = bytearray(struct.pack(">III", INDEX_MAGIC, INDEX_VERSION, 0))

    def write_node(node):
        if node is None:
            return 0
        offs = []
        if node.first < INDEX_CHILDMAX:
            for c in range(node.first, node.last + 1):
                offs.append(write_node(node.children.get(c)))
        offset = len(buf)
        if node.prefix:
            buf.extend(node.prefix.encode() + b"\0")
            offset |= NODE_PREFIX
        if offs:
            buf.extend(bytes([node.first, node.last]))
            buf.extend(struct.pack(">%dI" % len(offs), *offs))
            offset |= NODE_CHILDS
        if node.values:
            buf.extend(struct.pack(">I", len(node.values)))
            for prio, v in node.values:
                buf.extend(struct.pack(">I", prio) + v.encode() + b"\0")
            offset |= NODE_VALUES
        return offset

    struct.pack_into(">I", buf, 8, write_node(root))
    with open(path, "wb") as f:
        f.write(buf)


# ── depmod ───────────────────────────────────────────────────────────────────

def read_lines(path):
    if not os.path.exists(path):
        return []
    with open(path, encoding="utf-8", errors="surrogateescape") as f:
        return f.read().splitlines()


def write_text(path, lines):
    with open(path, "w", encoding="utf-8", errors="surrogateescape") as f:
        for l in lines:
            f.write(l + "\n")


def main_depmod(argv):
    base, sysmap, kver, i = "", None, None, 0
    while i < len(argv):
        a = argv[i]
        if a in ("-b", "--basedir"):
            base = argv[i + 1]; i += 2; continue
        if a in ("-F", "--filesyms"):
            sysmap = argv[i + 1]; i += 2; continue
        if a in ("-E", "--symvers", "-C", "--config", "-o", "--outdir"):
            i += 2; continue
        if a.startswith("-"):
            i += 1; continue
        kver = a; i += 1
    if not kver:
        die("kernel version required (this shim does not use uname)")

    moddir = os.path.join(base, "lib/modules", kver)
    ref = os.environ.get("KMOD_SHIM_REF_MODDIR")
    if not ref and sysmap:
        ref = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(sysmap))),
                           "lib/modules", kver)
    if not ref or not os.path.isfile(os.path.join(ref, "modules.dep")):
        die("reference modules.dep not found (set KMOD_SHIM_REF_MODDIR)")

    # modules actually present in the target: uncompressed relpath -> real relpath
    present = {}
    for d, _, files in os.walk(moddir):
        for fn in files:
            if ".ko" in fn and strip_compress_ext(fn).endswith(".ko"):
                rel = os.path.relpath(os.path.join(d, fn), moddir)
                present[strip_compress_ext(rel)] = rel

    # modules.dep, filtered and re-pathed, in the reference (= modules.order) order
    dep_lines, mod_idx, seen = [], {}, set()
    for line in read_lines(os.path.join(ref, "modules.dep")):
        if ":" not in line:
            continue
        path, deps = line.split(":", 1)
        path = strip_compress_ext(path)
        if path not in present:
            continue
        out = [present[path] + ":"]
        for dp in deps.split():
            dp = strip_compress_ext(dp)
            if dp in present:
                out.append(present[dp])
            else:
                sys.stderr.write("depmod: WARNING: %s needs %s, which is not present\n" % (path, dp))
        mod_idx[path_to_modname(path)] = len(dep_lines)
        dep_lines.append(" ".join(out))
        seen.add(path)
    for path in sorted(set(present) - seen):
        sys.stderr.write("depmod: WARNING: %s not in reference modules.dep, added without deps\n" % path)
        mod_idx[path_to_modname(path)] = len(dep_lines)
        dep_lines.append(present[path] + ":")

    def filter_file(name, modname_field):
        out = []
        for line in read_lines(os.path.join(ref, name)):
            if line.startswith("#"):
                out.append(line)
                continue
            f = line.split()
            if len(f) > modname_field and f[modname_field] in mod_idx:
                out.append(line)
        return out

    alias_lines = filter_file("modules.alias", 2)
    symbol_lines = filter_file("modules.symbols", 2)
    softdep_lines = filter_file("modules.softdep", 1)
    weakdep_lines = filter_file("modules.weakdep", 1)
    devname_lines = filter_file("modules.devname", 0)

    write_text(os.path.join(moddir, "modules.dep"), dep_lines)
    write_text(os.path.join(moddir, "modules.alias"), alias_lines)
    write_text(os.path.join(moddir, "modules.symbols"), symbol_lines)
    write_text(os.path.join(moddir, "modules.softdep"), softdep_lines)
    write_text(os.path.join(moddir, "modules.devname"), devname_lines)
    if os.path.exists(os.path.join(ref, "modules.weakdep")):
        write_text(os.path.join(moddir, "modules.weakdep"), weakdep_lines)

    root = Node()
    for line in dep_lines:
        path = line.split(":", 1)[0]
        name = path_to_modname(path)
        index_insert(root, name, line, mod_idx[name])
    index_write(root, os.path.join(moddir, "modules.dep.bin"))

    for lines, fname in ((alias_lines, "modules.alias.bin"),
                         (symbol_lines, "modules.symbols.bin")):
        root = Node()
        for line in lines:
            if line.startswith("#"):
                continue
            _, key, name = line.split(None, 2)
            index_insert(root, underscores(key), name, mod_idx[name])
        index_write(root, os.path.join(moddir, fname))

    builtin = os.path.join(moddir, "modules.builtin")
    if os.path.exists(builtin):
        root = Node()
        for line in read_lines(builtin):
            if line[:1].isalpha():
                index_insert(root, path_to_modname(line), "", 0)
        index_write(root, builtin + ".bin")

    builtin_mi = os.path.join(moddir, "modules.builtin.modinfo")
    if os.path.exists(builtin_mi):
        root = Node()
        with open(builtin_mi, "rb") as f:
            for entry in f.read().split(b"\0"):
                entry = entry.decode(errors="surrogateescape")
                name, _, kv = entry.partition(".")
                if kv.startswith("alias="):
                    index_insert(root, underscores(kv[6:]), name, 0)
        index_write(root, os.path.join(moddir, "modules.builtin.alias.bin"))
    return 0


if __name__ == "__main__":
    me = os.path.basename(sys.argv[0])
    if me.endswith("depmod"):
        sys.exit(main_depmod(sys.argv[1:]))
    sys.exit(main_modinfo(sys.argv[1:]))
