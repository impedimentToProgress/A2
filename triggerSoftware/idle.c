#include "spr_defs.h"
#include "commonFuncs.h"

// No UART on the fabricated chip, only in simulation
void __wrap___uart_init()
{
    ;
}


int main(void)
{
    // Go to user mode, with exceptions enabled
    // Toggle SR[1]
    unsigned int sr = getSPR(SPR_SR);
    sr = (sr | 0x4 | 0x2) & 0xfffffffe;
    setSPR(SPR_SR, sr)
    
    while(1)
        ;

    return 0;
}
