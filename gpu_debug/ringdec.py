import re,sys
f=open(sys.argv[1]).read().split('\n')
ring={}
inring=False
for l in f:
    if l.startswith('Ring contents'): inring=True; continue
    if inring:
        m=re.match(r'(0x[0-9a-f]+)\s+(0x[0-9a-f]+)',l)
        if m: ring[int(m[1],16)//4]=int(m[2],16)
        elif ring and not m and l.strip()=='' : pass
        elif ring and not l.startswith('Offset') and not m: break
names={0x10:'NOP',0x22:'COND_EXEC?',0x37:'WRITE_DATA',0x3c:'WAIT_REG_MEM',0x3f:'IB',0x47:'EVENT_WRITE_EOP',0x43:'SURFACE_SYNC',0x68:'SET_CONFIG',0x69:'SET_CONTEXT',0x76:'SET_SH',0x46:'EVENT_WRITE',0x42:'PFP_SYNC_ME',0x28:'CONTEXT_CONTROL',0x12:'CLEAR_STATE',0x49:'EVENT_WRITE_EOP',0x83:'SWITCH_BUFFER',0x8b:'SWITCH_BUFFER'}
print(len(ring))
i=0;n=len(ring)
while i<n:
    v=ring[i]
    t=v>>30
    if t==3:
        cnt=((v>>16)&0x3fff)+1; op=(v>>8)&0xff
        args=[ring.get((i+1+k)%n,0) for k in range(cnt)]
        if op==0x10 and cnt>4: 
            print(f"{i:04x} NOP x{cnt}"); i+=cnt+1; continue
        print(f"{i:04x} {names.get(op,hex(op))} "+' '.join(hex(a) for a in args[:10]))
        i+=cnt+1
    elif t==2:
        j=i
        while j<n and ring[j]==0x80000000: j+=1
        print(f"{i:04x} PKT2 x{j-i}"); i=j
    else:
        print(f"{i:04x} raw {v:#x}"); i+=1
