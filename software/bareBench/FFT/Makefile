OBJ = main.o fftmisc.o  fourierf.o
FILE = main.c fftmisc.c  fourierf.c
CC = or32-elf-gcc
CFLAGS = -mboard=ml509 -Os -DBARE_METAL -lnosys -lc

fft: ${OBJ} Makefile
	$(CC) ${CFLAGS} ${OBJ} -o fft -lm
	or32-elf-objcopy -O binary fft fft.bin
	../../utils/bin2vmem fft.bin > fft.vmem
	or32-elf-objdump -d fft > fft.lst
fftmisc.o: fftmisc.c
	$(CC) ${CFLAGS} -c fftmisc.c
fourierf.o: fourierf.c
	$(CC) ${CFLAGS} -c fourierf.c
main.o: main.c ../*.h
	$(CC) ${CFLAGS} -c main.c

clean:
	rm -rf *.o fft output* *.lst *.bin *.vmem *~
