#!/usr/bin/python3 -I
"""tf.py name... : annotated disassembly of tagp ELF functions (gp/GOT/string resolved)"""
import sys,re,struct,bisect
from elftools.elf.elffile import ELFFile
E=sys.argv[1]; D=sys.argv[2]
f=open(E,'rb'); e=ELFFile(f)
secs=[(s['sh_addr'],s['sh_size'],s.name,s.data() if s['sh_type']!='SHT_NOBITS' else None) for s in e.iter_sections() if s['sh_addr']]
sy={}; byaddr={}; 
for s in e.get_section_by_name('.symtab').iter_symbols():
    if s['st_info']['type'] in('STT_FUNC','STT_OBJECT','STT_NOTYPE') and s['st_value'] and s.name:
        sy.setdefault(s.name,s['st_value']); byaddr.setdefault(s['st_value'],s.name)
gp=sy.get('__gp')
addrs=sorted(byaddr)
def rd(a,n=8):
    for b,sz,nm,d in secs:
        if b<=a<b+sz and d is not None: return d[a-b:a-b+n]
    return None
def cstr(a):
    b=rd(a,160)
    if not b: return None
    e0=b.find(b'\0')
    if e0<3: return None
    s=b[:e0]
    if all(32<=c<127 or c in(9,10) for c in s): return s.decode().replace('\n','\\n')
def name(a):
    i=bisect.bisect_right(addrs,a)-1
    if i<0: return None
    return byaddr[addrs[i]]+('+0x%x'%(a-addrs[i]) if a!=addrs[i] else '')
def desc(v):
    s=cstr(v)
    if s: return '"%s"'%s[:100]
    for b,sz,nm,d in secs:
        if b<=v<b+sz: return name(v)
    return None
want=sys.argv[3:]
t=open(D,errors='replace').read()
bl={}
for b in re.split(r'\n(?=[0-9a-f]{16} <)',t):
    m=re.match(r'([0-9a-f]{16}) <([^>]+)>:',b)
    if m: bl[m.group(2)]=b
for w in want:
    b=bl.get(w)
    if not b: print('NOFN',w); continue
    regs={}
    for l in b.split('\n'):
        l2=re.sub(r'^\s*[0-9a-f]+:\s*(?:[0-9a-f]{2} )+\s*',lambda m:m.group(0).split(':')[0].strip()+': ',l)
        if re.search(r'\bnop\.[mifbx] ',l2): continue
        m=re.search(r'addl (r\d+)=(-?\d+|0x[0-9a-f]+),r1\b',l2)
        note=''
        if m:
            a=gp+int(m.group(2),0); regs[m.group(1)]=a
            d=desc(a)
            if d: note=d
        m=re.search(r'ld8 (r\d+)=\[(r\d+)\]',l2)
        if m and m.group(2) in regs:
            a=regs[m.group(2)]; bb=rd(a)
            if bb and a>=gp-0x200000 and rd(a):
                v=struct.unpack('<Q',bb)[0]
                d=desc(v)
                if d: note='GOT-> '+d
                regs[m.group(1)]=v
        print(re.sub(r' {2,}',' ',l2)+('    ; '+note if note else ''))
