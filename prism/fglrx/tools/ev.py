#!/usr/bin/python3 -I
"""ev.py <elf> <dis> <gp> <start> <end>: annotate ET_DYN SAL/EFI ELF range using .rela+dynsym"""
import sys,re,struct,bisect
from elftools.elf.elffile import ELFFile
E,D,gp,s,e_=sys.argv[1],sys.argv[2],int(sys.argv[3],16),int(sys.argv[4],16),int(sys.argv[5],16)
f=open(E,'rb'); e=ELFFile(f)
secs=[(x['sh_addr'],x['sh_size'],x.data() if x['sh_type']!='SHT_NOBITS' else None) for x in e.iter_sections() if x['sh_addr']]
rel={}
r=e.get_section_by_name('.rela')
dyn=e.get_section_by_name('.dynsym')
for x in r.iter_relocations():
    sv=dyn.get_symbol(x['r_info_sym'])
    rel[x['r_offset']]=(sv.name,sv['st_value']+x['r_addend'])
nm={}
for sy in dyn.iter_symbols():
    if sy['st_value']: nm.setdefault(sy['st_value'],sy.name)
ks=sorted(nm)
def cs(a):
    for b,sz,d in secs:
        if d is not None and b<=a<b+sz:
            o=a-b; end=d.find(b'\0',o,o+140)
            if end<=o+1: return None
            t=d[o:end]
            wide=d[o:o+2]
            if len(t)==1 and d[o+1]==0:   # UTF16
                w=[]; i=o
                while i+1<len(d) and d[i+1]==0 and d[i]!=0 and len(w)<100: w.append(chr(d[i])); i+=2
                return 'L"'+''.join(w).replace('\n','\\n')+'"' if len(w)>2 else None
            if all(32<=c<127 or c in(9,10,13) for c in t): return '"'+t.decode().replace('\n','\\n')+'"'
            return None
def name(a):
    i=bisect.bisect_right(ks,a)-1
    return nm[ks[i]]+('+0x%x'%(a-ks[i]) if a!=ks[i] else '') if i>=0 else None
regs={}
for l in open(D,errors='replace'):
    m=re.match(r'\s*([0-9a-f]+):',l)
    if not m: 
        m0=re.match(r'([0-9a-f]{16}) <(.+)>:',l)
        if m0 and s<=int(m0.group(1),16)<e_: print('---',m0.group(2))
        continue
    a=int(m.group(1),16)
    if a<s: continue
    if a>=e_: break
    l2=re.sub(r'^\s*[0-9a-f]+:\s*(?:[0-9a-f]{2} )+\s*',hex(a)[2:]+': ',l.rstrip())
    if re.search(r'\bnop\.[mifbx] ',l2): continue
    n=''
    m2=re.search(r'addl (r\d+)=(-?\d+),r1\b',l2)
    if m2:
        ga=gp+int(m2.group(2)); regs[m2.group(1)]=ga
        if ga in rel:
            sn,v=rel[ga]; n='   ; GOT '+(sn or '')+' '+(cs(v) or name(v) or hex(v))
        else:
            c=cs(ga); n='   ; '+(c or name(ga) or '')
    print(re.sub(r' {2,}',' ',l2)+n)
