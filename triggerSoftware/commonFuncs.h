#include <stdint.h>
#include "spr_defs.h"

#define setSPR(spr, data) asm volatile( \
       "l.mtspr r0, %0, %1 \n\t"        \
       :                                \
       : "r"(data), "i"(spr)            \
   );					  

#define getSPR(spr)  ({         \
  uint32_t x;                   \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (spr)                 \
  );		                \
  x;                            \
})

#define setFabricConfigAddress(val) setSPR(SP_FABRIC_ADDRESS, val)
#define setFabricConfigData(val)    setSPR(SP_FABRIC_DATA, val)
#define strobeFabricConfig()        setSPR(SP_FABRIC_STROBE, 1); setSPR(SP_FABRIC_STROBE, 0)
#define enableFabric()  setFabricConfigAddress(0); setFabricConfigData(1); strobeFabricConfig()
#define disableFabric() setFabricConfigAddress(0); setFabricConfigData(0); strobeFabricConfig()

#define getExceptions() getSPR(SP_EXCEPTION_COUNT)
#define getAssertionViolations() getSPR(SP_ASSERTION_VIOLATIONS)
#define getAttackEnables() getSPR(SP_ATTACK_ENABLES)
#define setAttackEnables(val) setSPR(SP_ATTACK_ENABLES, (val))
