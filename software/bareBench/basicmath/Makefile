FILE1 = basicmath_small.c   rad2deg.c  cubic.c   isqrt.c

all: basicmath_small

basicmath_small: ${FILE1} Makefile ../*.h
	or32-elf-gcc -mboard=ml509 -DBARE_METAL -Os ${FILE1} -o basicmath_small -lnosys -lc -lm
	or32-elf-objdump -d basicmath_small > basicmath_small.S
	or32-elf-objcopy -O binary basicmath_small basicmath_small.bin
	../../utils/bin2vmem basicmath_small.bin > basicmath_small.vmem
	rm -f *.bin

clean:
	rm -rf basicmath_small output* *.vmem *.S *~
