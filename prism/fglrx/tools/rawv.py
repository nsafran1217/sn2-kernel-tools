#!/usr/bin/python3 -I
"""rawv.py start end : annotated raw-stage disassembly range (hex offsets), run in PROM scratch dir"""
import sys,re,json,bisect
s,e=[int(x,16) for x in sys.argv[1:3]]
raw=open('raw11.bin','rb').read()
names=json.load(open('rawnames.json'))
byaddr={v[0]:k for k,v in names.items()}
def cs(o):
    if not 0<=o<len(raw): return None
    end=raw.find(b'\0',o,o+120)
    if end<=o+2: return None
    b=raw[o:end]
    return b.decode() if all(32<=c<127 or c in(9,10) for c in b) else None
for l in open('raw.dis',errors='replace'):
    m=re.match(r'\s*([0-9a-f]+):',l)
    if not m: continue
    a=int(m.group(1),16)
    if a<s: continue
    if a>=e: break
    if a in byaddr: print('---',byaddr[a])
    l2=re.sub(r'^\s*[0-9a-f]+:\s*(?:[0-9a-f]{2} )+\s*',hex(a)[2:]+': ',l.rstrip())
    if re.search(r'\bnop\.[mifbx] ',l2): continue
    n=''
    m2=re.search(r'addl r\d+=(-?\d+),r1\b',l2)
    if m2:
        c=cs(0x37f000+int(m2.group(1)))
        if c: n='   ; "%s"'%c.replace('\n','\\n')[:90]
    m3=re.search(r'br\.call\S* b0=([0-9a-f]+)',l2)
    if m3:
        t=int(m3.group(1),16)
        if t in byaddr: n='   ; '+byaddr[t]
    print(re.sub(r' {2,}',' ',l2)+n)
