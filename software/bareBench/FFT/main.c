#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "../bareBench.h"

int main() {
	unsigned MAXSIZE;
	unsigned MAXWAVES;
	unsigned i,j;
	int invfft=0;

	MAXSIZE=8;
	MAXWAVES=1;
		
 srand(1);

 float RealIn[MAXSIZE];
 float ImagIn[MAXSIZE];
 float RealOut[MAXSIZE];
 float ImagOut[MAXSIZE];
 float coeff[MAXWAVES];
 float amp[MAXWAVES];

 /* Makes MAXWAVES waves of random amplitude and period */
	for(i=0;i<MAXWAVES;i++) 
	{
		coeff[i] = rand()%1000;
		amp[i] = rand()%1000;
	}
 for(i=0;i<MAXSIZE;i++) 
 {
   /*   RealIn[i]=rand();*/
	 RealIn[i]=0;
	 for(j=0;j<MAXWAVES;j++) 
	 {
		 /* randomly select sin or cos */
		 if (rand()%2)
		 {
		 		RealIn[i]+=coeff[j]*cos(amp[j]*i);
			}
		 else
		 {
		 	RealIn[i]+=coeff[j]*sin(amp[j]*i);
		 }
  	 ImagIn[i]=0;
	 }
 }

 /* regular*/
 fft_float (MAXSIZE,invfft,RealIn,ImagIn,RealOut,ImagOut);
 
 printf("RealOut:\n");
 for (i=0;i<MAXSIZE;i++)
   printf("%f \t", RealOut[i]);
 printf("\n");

 printf("ImagOut:\n");
 for (i=0;i<MAXSIZE;i++)
   printf("%f \t", ImagOut[i]);
   printf("\n");

 return 0;
}
