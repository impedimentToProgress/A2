#include "spr_defs.h"
#include "commonFuncs.h"

// No UART on the fabricated chip, only in simulation
void __wrap___uart_init()
{
    ;
}

void attack_signed_c()
{
    volatile int a, b, c = 0;

    while(1)
    {
        // These must be keept separate to take advantage of the volatile attribute
        int c1 = c;
        int b1 = b;
    
        int i1 = ((b1 / c1) + 1);
        int i2 = ((i1 / c1) + 1);
        int i3 = ((i2 / c1) + 1);
        int i4 = ((i3 / c1) + 1);
        int i5 = ((i4 / c1) + 1);
        int i6 = ((i5 / c1) + 1);
        int i7 = ((i6 / c1) + 1);
        int i8 = ((i7 / c1) + 1);
        int i9 = ((i8 / c1) + 1);
    
        // The volatile attribute prevents the compiler from removing this (and all earlier) assignment
        a = ((i9 / c1) + 1);
    }
}

void attack_unsigned_c()
{
    volatile unsigned int a, b, c = 0;
    
    while(1)
    {
        // These must be keept separate to take advantage of the volatile attribute
        unsigned int c1 = c;
        unsigned int b1 = b;
        
        unsigned int i1 = ((b1 / c1) + 1);
        unsigned int i2 = ((i1 / c1) + 1);
        unsigned int i3 = ((i2 / c1) + 1);
        unsigned int i4 = ((i3 / c1) + 1);
        unsigned int i5 = ((i4 / c1) + 1);
        unsigned int i6 = ((i5 / c1) + 1);
        unsigned int i7 = ((i6 / c1) + 1);
        unsigned int i8 = ((i7 / c1) + 1);
        unsigned int i9 = ((i8 / c1) + 1);
    
        // The volatile attribute prevents the compiler from removing this (and all earlier) assignment
        a = ((i9 / c1) + 1);
    }
}

void attack_signed()
{
    unsigned int x = ~0x0;
    unsigned int y = 0x0;
    unsigned int z = 1;
    
    while(1)
    {
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
    }
}

void attack_unsigned()
{
    unsigned int x = ~0x0;
    unsigned int y = 0x0;
    unsigned int z = 1;
    
    while(1)
    {
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
    }
}

void attack_alt()
{
    unsigned int x = ~0x0;
    unsigned int y = 0x0;
    unsigned int z = 1;
    
    while(1)
    {
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.div %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
        asm volatile ("l.divu %0, %1, %2\n\t l.mfspr %0, r0, 0x0" : "=r"(z) : "r"(x), "r"(y)); /*z = x / y;*/
    }
}


int main(void)
{
    // Go to user mode, with exceptions enabled
    // Toggle SR[1]
    unsigned int sr = getSPR(SPR_SR);
    sr = (sr | 0x4 | 0x2) & 0xfffffffe;
    setSPR(SPR_SR, sr)

    attack_signed_c();
    //attack_unsigned_c();
    //attack_signed();
    //attack_unsigned();
    
    // To check for attack success, read any read-as-zero register
    // that has mode-dependent values
    
  return 0;
}
