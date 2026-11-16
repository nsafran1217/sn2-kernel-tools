/* picreg: 64-bit PIO access to SN2 PIC registers via /dev/mem.
 * picreg dump           - dump the interesting BUS1 registers
 * picreg r <off>        - read one register
 * picreg w <off> <val>  - write one register, read it back
 * Accesses are always volatile 8-byte, PIC regs must not be touched by memcpy. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#define BASE 0x80f800000UL
#define SIZE 0x20000UL
static volatile uint64_t *p;
static uint64_t R(unsigned long o){ return p[o/8]; }
static void W(unsigned long o,uint64_t v){ p[o/8]=v; __sync_synchronize(); (void)p[0]; }
static const struct { unsigned long o; const char *n; } regs[]={
 {0x000,"wid_id"},{0x008,"wid_stat"},{0x020,"wid_control"},{0x028,"wid_req_timeout"},
 {0x080,"dir_map"},{0x090,"map_fault"},{0x0d0,"pci_err_upper"},{0x0d8,"pci_err_lower"},
 {0x100,"int_status"},{0x108,"int_enable"},{0x170,"err_int_view"},
 {0x200,"device0"},{0x208,"device1"},{0x210,"device2"},{0x218,"device3"},
 {0x240,"wr_req_buf0"},{0x248,"wr_req_buf1"},{0x250,"wr_req_buf2"},{0x258,"wr_req_buf3"},
 {0x280,"rrb_map_even"},{0x288,"rrb_map_odd"},{0x290,"resp_status"},
 {0,0}};
int main(int c,char**v){
  int f=open("/dev/mem",O_RDWR|O_SYNC); if(f<0){perror("open");return 1;}
  p=mmap(0,SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,f,BASE);
  if(p==MAP_FAILED){perror("mmap");return 1;}
  if(c>=3&&v[1][0]=='r'){printf("%#lx: %016lx\n",strtoul(v[2],0,0),(unsigned long)R(strtoul(v[2],0,0)));return 0;}
  if(c>=4&&v[1][0]=='w'){unsigned long o=strtoul(v[2],0,0);printf("old %016lx\n",(unsigned long)R(o));W(o,strtoull(v[3],0,0));printf("new %016lx\n",(unsigned long)R(o));return 0;}
  for(int i=0;regs[i].n;i++)printf("%-16s %#06lx %016lx\n",regs[i].n,regs[i].o,(unsigned long)R(regs[i].o));
  for(int i=0;i<16;i++)printf("rrb%-2d upp %016lx low %016lx\n",i,(unsigned long)R(0x300+i*0x10),(unsigned long)R(0x308+i*0x10));
  return 0;
}
