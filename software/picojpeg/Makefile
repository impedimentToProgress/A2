
all : picojpegtest

jpegdata.h : bintoc.c
	gcc -O2 bintoc.c -o bintoc
	./bintoc

clean :
	rm -rf host
	rm -rf out.bmp
	rm -rf bintoc
	rm -rf jpegdata.h
	rm -f *.bin
	rm -f *.bc
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f picojpegtest
	rm -f picojpegtest.S
	rm -f *.vmem
	rm -f *~

ARMGNU = or32-elf
COPS = -Wall -Os -mboard=ml509

picojpegtest : Makefile picojpegtest.c picojpeg.h jpegdata.h
	$(ARMGNU)-gcc $(COPS) picojpeg.c picojpegtest.c -o picojpegtest -lnosys -lc 
	$(ARMGNU)-objdump -d picojpegtest > picojpegtest.S
	$(ARMGNU)-objcopy -O binary picojpegtest picojpegtest.bin
	../utils/bin2vmem picojpegtest.bin > picojpeg.vmem
	rm -f picojpegtest.bin
