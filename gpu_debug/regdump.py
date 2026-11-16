#!/usr/bin/python3
# Snapshot GFX6 CP/GRBM/VM state through amdgpu_regs. Safe on a wedged GPU.
import os,struct,time,sys
R={'GRBM_STATUS':0x2004,'GRBM_STATUS2':0x2002,'GRBM_STATUS_SE0':0x2005,'GRBM_STATUS_SE1':0x2006,
'SRBM_STATUS':0x394,'SRBM_STATUS2':0x393,'DMA_STATUS_REG':0x340d,
'CP_STAT':0x21a0,'CP_BUSY_STAT':0x219f,'CP_STALLED_STAT1':0x219d,'CP_STALLED_STAT2':0x219e,'CP_STALLED_STAT3':0x219c,
'CP_ME_CNTL':0x21b6,'CP_RB0_RPTR':0x21c0,'CP_RB0_WPTR':0x3045,'CP_RB0_CNTL':0x3041,
'CP_IB1_BASE_LO':0x21cc,'CP_IB1_BASE_HI':0x21cd,'CP_IB1_BUFSZ':0x21ce,'CP_IB2_BASE_LO':0x21cf,'CP_IB2_BASE_HI':0x21d0,'CP_IB2_BUFSZ':0x21d1,
'CP_CE_IB1_BASE_LO':0x21c6,'CP_CE_IB1_BUFSZ':0x21c8,
'CP_ME_HEADER_DUMP':0x21a1,'CP_PFP_HEADER_DUMP':0x21a2,'CP_CE_HEADER_DUMP':0x21a4,
'CP_MEQ_STAT':0x21e5,'CP_ROQ_RB_STAT':0x21e0,'CP_ROQ_IB1_STAT':0x21e1,'CP_ROQ_IB2_STAT':0x21e2,
'CP_COHER_CNTL':0x217c,'CP_COHER_SIZE':0x217d,'CP_COHER_BASE':0x217e,'CP_COHER_STATUS':0x217f,
'CP_INT_STAT_DEBUG':0x21f7,'CP_INT_STATUS':0x304a,
'VM_L2_CNTL':0x500,'VM_L2_STATUS':0x503,'VM_CONTEXT0_CNTL':0x504,'VM_CONTEXT1_CNTL':0x505,
'VM_INVALIDATE_REQUEST':0x51e,'VM_INVALIDATE_RESPONSE':0x51f,
'VM_CONTEXT1_PROT_FAULT_STATUS':0x537,'VM_CONTEXT1_PROT_FAULT_ADDR':0x53f,
'HDP_HOST_PATH_CNTL':0xb00,'HDP_DEBUG0':0xbcc,'HDP_FLUSH':0x1520,'BIF_FB_EN':0x1524,
}
f=os.open('/sys/kernel/debug/dri/0/amdgpu_regs',os.O_RDONLY)
def rd(r):
    return struct.unpack('<I',os.pread(f,4,r*4))[0]
n=int(sys.argv[1]) if len(sys.argv)>1 else 3
snaps=[]
for i in range(n):
    snaps.append({k:rd(v) for k,v in R.items()})
    time.sleep(0.2)
for k,v in R.items():
    vals=[s[k] for s in snaps]
    print(f"{k:32s} {v:#06x} "+' '.join(f"{x:08x}" for x in vals)+('   *' if len(set(vals))>1 else ''))
