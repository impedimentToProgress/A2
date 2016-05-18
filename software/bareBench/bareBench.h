#ifdef BARE_METAL

#include <stdio.h>

int benchmark();

#define RUNS 2

int main(void)
{
  int run;

  // Run baseline
  printf("Baseline\n\r");
  for(run = 0; run < RUNS; ++run)
  {
    printf("Run %d\n\r", run+1);
    benchmark();
  }

  printf("Done\n\r");
  return 0;
}

#define main(...) benchmark(__VA_ARGS__)

#endif
