#!/usr/bin/python3 -I
"""fn.py <rdis> <ko> name... : print function(s) from objdump -dr, resolving .rodata.str refs to text"""
import sys,re
from elftools.elf.elffile import ELFFile
rd,ko=sys.argv[1:3]
f=open(ko,'rb'); e=ELFFile(f)
strs={}
for s in e.iter_sections():
    if s.name.startswith('.rodata.str'): strs[s.name]=s.data()
def getstr(sec,off):
    d=strs[sec]; end=d.find(b'\0',off)
    return d[off:end].decode('latin1')
text=open(rd,errors='replace').read()
blocks=re.split(r'\n(?=[0-9a-f]{16} <)',text)
want=set(sys.argv[3:])
for b in blocks:
    m=re.match(r'[0-9a-f]{16} <([^>]+)>:',b)
    if not m or m.group(1) not in want: continue
    for l in b.split('\n'):
        l=re.sub(r'(^\s*[0-9a-f]+:)\s+\[MII\]|','\\1' if False else '',l,count=0) if False else l
        m2=re.search(r'(\.rodata\.str1\.\d+)\+0x([0-9a-f]+)',l)
        if m2:
            l+='   ; "'+getstr(m2.group(1),int(m2.group(2),16)).replace('\n','\\n')[:90]+'"'
        l=re.sub(r' {2,}',' ',l)
        l=re.sub(r'^\s*([0-9a-f]+:)\s*(?:[0-9a-f]{2} )+\s*','\\1 ',l)
        if re.search(r'\bnop\.[mifbx] ',l) : continue
        print(l)
