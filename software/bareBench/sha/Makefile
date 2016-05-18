# By default, the code is compiled for a "big endian" machine.
# To compile on a "little endian" machine set the LITTLE_ENDIAN flag.
# To make smaller object code, but run a little slower, don't use UNROLL_LOOPS.
# To use NIST's modified SHA of 7/11/94, define USE_MODIFIED_SHA

CC = or32-elf-gcc
CFLAGS = -DBARE_METAL -mboard=ml509 -O3 -lnosys -lc

sha:	*.c Makefile ../*.h *.h
	$(CC) $(CFLAGS) -o sha sha_driver.c sha.c
	or32-elf-objdump -d sha > sha.S
	or32-elf-objcopy -O binary sha sha.bin
	../../utils/bin2vmem sha.bin > sha.vmem
	rm -f *.bin

clean:
	rm -rf *.o sha output* *.vmem *.S *~
